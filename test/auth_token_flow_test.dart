import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swb_advance/app/core/services/auth/auth_tokens.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo_impl.dart';

void main() {
  test(
    'login refreshes an expired token and retries the original request',
    () async {
      final tokenStorage = MemoryTokenStorage();
      final apiService = ApiService(
        tokenStorage: tokenStorage,
        baseUrl: 'https://backend.test',
        apiKey: 'public-api-key',
        loginPath: '/auth/login',
        useSupabaseGrantType: false,
      );
      var profileRequestCount = 0;
      apiService.dio.httpClientAdapter = RecordingAdapter((options) {
        if (options.path == '/auth/login') {
          expect(options.headers['Authorization'], isNull);
          expect(options.headers['apikey'], 'public-api-key');
          return _jsonResponse(
            '{"access_token":"access-token","refresh_token":"refresh-token","token_type":"Bearer","expires_in":3600,"user":{"id":"user-id","email":"person@example.com"}}',
          );
        }

        if (options.path == '/auth/v1/token') {
          expect(options.extra['skipAuthToken'], isTrue);
          expect(options.extra['skipAuthRefresh'], isTrue);
          expect(options.data, {'refresh_token': 'refresh-token'});
          return _jsonResponse(
            '{"access_token":"refreshed-access-token","refresh_token":"rotated-refresh-token","token_type":"Bearer","expires_in":3600}',
          );
        }

        if (options.path == '/profile') {
          profileRequestCount++;
          if (profileRequestCount == 1) {
            expect(options.headers['Authorization'], 'Bearer access-token');
            return _jsonResponse('{"message":"expired"}', statusCode: 401);
          }
          expect(
            options.headers['Authorization'],
            'Bearer refreshed-access-token',
          );
          return _jsonResponse('{}');
        }

        fail('Unexpected request path: ${options.path}');
      });
      final repository = AuthRepositoryImpl(apiService, tokenStorage);

      final signInResult = await repository.signIn(
        email: 'person@example.com',
        password: 'password',
      );
      signInResult.fold((error) => fail(error), (_) {});

      final response = await apiService.dio.get<Map<String, dynamic>>(
        '/profile',
      );

      expect(response.statusCode, 200);
      expect(profileRequestCount, 2);
      expect(
        (await tokenStorage.read())?.accessToken,
        'refreshed-access-token',
      );
      expect(
        (await tokenStorage.read())?.refreshToken,
        'rotated-refresh-token',
      );
    },
  );
}

class MemoryTokenStorage implements TokenStorage {
  AuthTokens? tokens;

  @override
  Future<void> save(AuthTokens tokens) async {
    this.tokens = tokens;
  }

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> clear() async {
    tokens = null;
  }
}

class RecordingAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) onFetch;

  RecordingAdapter(this.onFetch);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return onFetch(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(String body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    body,
    statusCode,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
}
