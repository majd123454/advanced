import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swb_advance/app/core/services/auth/secure_token_storage.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_config.dart';

import 'auth_interceptor.dart';

class ApiService {
  final Dio _dio;

  factory ApiService.fromEnvironment({TokenStorage? tokenStorage}) {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final usesSupabaseDefaults = baseUrl == null;

    return ApiService(
      tokenStorage: tokenStorage,
      baseUrl: baseUrl,
      apiKey:
          dotenv.env['API_KEY'] ??
          (usesSupabaseDefaults ? SupabaseConfig.supabaseAnonKey : null),
      loginPath:
          dotenv.env['LOGIN_PATH'] ??
          (usesSupabaseDefaults ? '/auth/v1/token' : '/auth/login'),
      useSupabaseGrantType:
          dotenv.env['USE_SUPABASE_GRANT_TYPE']?.toLowerCase() != 'false',
    );
  }

  ApiService({
    Dio? dio,
    TokenStorage? tokenStorage,
    String? baseUrl,
    String? apiKey,
    this.loginPath = '/auth/v1/token',
    this.useSupabaseGrantType = true,
  }) : _dio =
           dio ??
           Dio(
             _baseOptions(
               baseUrl: baseUrl,
               apiKey: apiKey,
               useSupabaseGrantType: useSupabaseGrantType,
             ),
           ) {
    _dio.interceptors.add(
      AuthInterceptor(tokenStorage ?? const SecureTokenStorage()),
    );
  }

  final String loginPath;
  final bool useSupabaseGrantType;

  static BaseOptions _baseOptions({
    String? baseUrl,
    String? apiKey,
    required bool useSupabaseGrantType,
  }) {
    final resolvedApiKey =
        apiKey ?? (baseUrl == null ? SupabaseConfig.supabaseAnonKey : null);

    return BaseOptions(
      baseUrl: baseUrl ?? SupabaseConfig.supabaseUrl,
      headers: {
        'Content-Type': 'application/json',
        if (resolvedApiKey != null) 'apikey': resolvedApiKey,
        if (resolvedApiKey != null && useSupabaseGrantType)
          'Authorization': 'Bearer $resolvedApiKey',
      },
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  Dio get dio => _dio;

  Future<Response<Map<String, dynamic>>> signIn({
    required String email,
    required String password,
  }) {
    return _dio.post<Map<String, dynamic>>(
      loginPath,
      queryParameters: useSupabaseGrantType ? {'grant_type': 'password'} : null,
      data: {'email': email, 'password': password},
      options: Options(extra: {'skipAuthToken': true}),
    );
  }
}
