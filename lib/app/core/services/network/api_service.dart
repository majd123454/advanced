import 'package:dio/dio.dart';
import 'package:swb_advance/app/core/services/supabase/supabase_config.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: SupabaseConfig.supabaseUrl,
              headers: {
                'Content-Type': 'application/json',
                'apikey': SupabaseConfig.supabaseAnonKey,
                'Authorization': 'Bearer ${SupabaseConfig.supabaseAnonKey}',
              },
              responseType: ResponseType.json,
              sendTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  Future<Response<Map<String, dynamic>>> signIn({
    required String email,
    required String password,
  }) {
    return _dio.post<Map<String, dynamic>>(
      '/auth/v1/token',
      queryParameters: {'grant_type': 'password'},
      data: {'email': email, 'password': password},
    );
  }

  Future<Response<Map<String, dynamic>>> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) {
    return _dio.post<Map<String, dynamic>>(
      '/auth/v1/signup',
      data: {
        'email': email,
        'password': password,
        'data': {'full_name': fullName, 'phone': phone},
      },
    );
  }
}
