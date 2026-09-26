import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:swb_advance/app/core/services/network/api_service.dart';
import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;

  AuthRepositoryImpl(this.apiService);

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
      final userData = response.data?['user'];

      if (userData is! Map<String, dynamic>) {
        return const Left('فشل تسجيل الدخول');
      }

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
