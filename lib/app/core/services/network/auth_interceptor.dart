import 'package:dio/dio.dart';

import '../auth/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;

  AuthInterceptor(this.tokenStorage);

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
}
