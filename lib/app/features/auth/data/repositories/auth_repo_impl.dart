import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:swb_advance/app/core/services/auth/auth_tokens.dart';
import 'package:swb_advance/app/core/services/auth/token_storage.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl(this.apiService, this.tokenStorage);

  @override
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.signIn(
        email: email,
        password: password,
      );
      final responseData = response.data;

      if (kDebugMode) {
        logger('LOGIN RESPONSE: $responseData', name: 'auth.login');
        logger(
          'ACCESS TOKEN: ${responseData?['access_token']}',
          name: 'auth.login',
        );
        logger(
          'REFRESH TOKEN: ${responseData?['refresh_token']}',
          name: 'auth.login',
        );
      }

      final accessToken = responseData?['access_token'];
      final userData = response.data?['user'];

      if (accessToken is! String || accessToken.isEmpty) {
        return const Left('لم يُرجع الخادم رمز الدخول');
      }
      if (userData is! Map<String, dynamic>) {
        return const Left('فشل تسجيل الدخول');
      }

      await tokenStorage.save(AuthTokens.fromJson(responseData!));

      return Right(
        UserEntity(
          id: userData['id'] as String,
          email: userData['email'] as String? ?? email,
        ),
      );
    } on DioException catch (e) {
      final message = _getDioErrorMessage(e);
      logger(message);
      return Left(_getAuthErrorMessage(message));
    } catch (e) {
      logger(e.toString());
      return Left(e.toString());
    }
  }

  String _getDioErrorMessage(DioException error) {
    final data = error.response?.data;
    logger(data.toString());
    if (data is Map<String, dynamic>) {
      return (data['error_description'] ?? data['msg'] ?? data['message'])
              as String? ??
          error.message ??
          'حدث خطأ في الاتصال';
    }
    return error.message ?? 'حدث خطأ في الاتصال';
  }

  String _getAuthErrorMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('invalid login credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    }
    if (lowerMessage.contains('email not confirmed')) {
      return 'يرجى تأكيد بريدك الإلكتروني أولاً';
    }
    if (lowerMessage.contains('user already registered')) {
      return 'هذا البريد الإلكتروني مسجل بالفعل';
    }
    if (lowerMessage.contains('password')) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    if (lowerMessage.contains('email')) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    if (lowerMessage.contains('rate limit')) {
      return 'تم تجاوز عدد المحاولات المسموحة. يرجى المحاولة لاحقاً';
    }

    return message;
  }
}
