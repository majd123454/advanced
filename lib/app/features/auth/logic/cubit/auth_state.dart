import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية قبل أي فعل
class AuthInitial extends AuthState {}

/// حالة التحميل أثناء انتظار استجابة السيرفر
class AuthLoading extends AuthState {}

/// حالة نجاح تسجيل الدخول مع تمرير بيانات المستخدم
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// حالة تسجيل الخروج أو عدم وجود مستخدم
class AuthUnauthenticated extends AuthState {}

/// حالة خطأ أثناء عملية تسجيل الدخول أو أي عملية أخرى
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة عند طلب المستخدم تأكيد البريد الإلكتروني
// class AuthEmailConfirmationRequired extends AuthState {
//   final String email;

//   const AuthEmailConfirmationRequired(this.email);

//   @override
//   List<Object?> get props => [email];
// }
