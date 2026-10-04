import 'package:dio/dio.dart';
import 'package:swb_advance/app/core/helper/logger.dart';

import '../auth/auth_tokens.dart';
import '../auth/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final String refreshTokenPath;
  final bool useSupabaseGrantType;
  Dio? _dio;

  AuthInterceptor(
    this.tokenStorage, {
    required this.refreshTokenPath,
    required this.useSupabaseGrantType,
  });

  void setDio(Dio dio) {
    _dio = dio;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuthToken'] != true) {
      final tokens = await tokenStorage.read();
      if (tokens != null) {
        options.headers['Authorization'] =
            '${tokens.tokenType} ${tokens.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final alreadyRetried = requestOptions.extra['retriedAfterRefresh'] == true;
    final skipRefresh = requestOptions.extra['skipAuthRefresh'] == true;

    if (err.response?.statusCode != 401 ||
        _dio == null ||
        alreadyRetried ||
        skipRefresh) {
      handler.next(err);
      return;
    }

    final tokens = await tokenStorage.read();
    if (tokens?.refreshToken == null) {
      handler.next(err);
      return;
    }

    try {
      final refreshResponse = await _dio!.post<Map<String, dynamic>>(
        refreshTokenPath,
        queryParameters: useSupabaseGrantType
            ? {'grant_type': 'refresh_token'}
            : null,
        data: {'refresh_token': tokens!.refreshToken},
        options: Options(
          extra: {'skipAuthToken': true, 'skipAuthRefresh': true},
        ),
      );
      final refreshedData = refreshResponse.data;
      final accessToken = refreshedData?['access_token'];
      if (refreshedData == null ||
          accessToken is! String ||
          accessToken.isEmpty) {
        throw const FormatException(
          'Token refresh response did not include an access token',
        );
      }

      final refreshedTokens = AuthTokens.fromJson(refreshedData);
      await tokenStorage.save(refreshedTokens);

      requestOptions.extra['retriedAfterRefresh'] = true;
      requestOptions.headers['Authorization'] =
          '${refreshedTokens.tokenType} ${refreshedTokens.accessToken}';
      handler.resolve(await _dio!.fetch<dynamic>(requestOptions));
    } on DioException catch (refreshError) {
      logger(
        'Token refresh failed: ${refreshError.message}',
        name: 'AuthInterceptor',
      );
      await tokenStorage.clear();
      handler.next(err);
    } on FormatException catch (refreshError) {
      logger('$refreshError', name: 'AuthInterceptor');
      await tokenStorage.clear();
      handler.next(err);
    } on TypeError catch (refreshError) {
      logger('$refreshError', name: 'AuthInterceptor');
      await tokenStorage.clear();
      handler.next(err);
    }
  }
}
