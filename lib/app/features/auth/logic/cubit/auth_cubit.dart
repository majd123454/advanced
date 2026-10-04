import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/login_usecase.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/signup_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signUpUseCase,
  }) : super(AuthInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await loginUseCase(email, password);

    result.fold((error) {
      if (error.contains('تأكيد بريدك')) {
        // emit(AuthEmailConfirmationRequired(email));
      } else {
        emit(AuthError(error));
      }
    }, (user) => emit(AuthAuthenticated(user)));
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
  }) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      address: address,
    );

    result.fold((error) {
      emit(AuthError(error));
    }, (user) => emit(AuthAuthenticated(user)));
  }
}
