import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swb_advance/app/core/services/auth/auth_tokens.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo_impl.dart';

void main() {
  test(
    'login saves tokens and sends access token on the next request',
    () async {
      final tokenStorage = MemoryTokenStorage();
      final apiService = ApiService(
        tokenStorage: tokenStorage,
        baseUrl: 'https://backend.test',
        apiKey: 'public-api-key',
        loginPath: '/auth/login',
        useSupabaseGrantType: false,
      );
      apiService.dio.httpClientAdapter = RecordingAdapter((options) {
        if (options.path == '/auth/login') {
          expect(options.headers['Authorization'], isNull);
          expect(options.headers['apikey'], 'public-api-key');
        } else {
          expect(options.headers['Authorization'], 'Bearer access-token');
        }
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
      expect((await tokenStorage.read())?.accessToken, 'access-token');
      expect((await tokenStorage.read())?.refreshToken, 'refresh-token');
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
  final void Function(RequestOptions options) onFetch;

  RecordingAdapter(this.onFetch);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onFetch(options);
    return ResponseBody.fromString(
      options.path == '/auth/login'
          ? '{"access_token":"access-token","refresh_token":"refresh-token","token_type":"Bearer","expires_in":3600,"user":{"id":"user-id","email":"person@example.com"}}'
          : '{}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
