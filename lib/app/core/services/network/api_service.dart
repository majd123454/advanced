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
      refreshTokenPath:
          dotenv.env['REFRESH_TOKEN_PATH'] ?? '/auth/v1/token',
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
    this.refreshTokenPath = '/auth/v1/token',
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
    final authInterceptor = AuthInterceptor(
      tokenStorage ?? const SecureTokenStorage(),
      refreshTokenPath: refreshTokenPath,
      useSupabaseGrantType: useSupabaseGrantType,
    );
    authInterceptor.setDio(_dio);
    _dio.interceptors.add(authInterceptor);
  }

  final String loginPath;
  final String refreshTokenPath;
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

  Future<Response<Map<String, dynamic>>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
  }) {
    final signupPath = dotenv.env['SIGNUP_PATH'] ?? '/auth/v1/signup';
    return _dio.post<Map<String, dynamic>>(
      signupPath,
      data: {
        'email': email,
        'password': password,
        'user_metadata': {
          'full_name': fullName,
          'phone': phone,
          'address': address,
        }
      },
      options: Options(extra: {'skipAuthToken': true}),
    );
  }

  Future<Response<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) {
    return _dio.post<Map<String, dynamic>>(
      refreshTokenPath,
      queryParameters: useSupabaseGrantType ? {'grant_type': 'refresh_token'} : null,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skipAuthToken': true}),
    );
  }
}
