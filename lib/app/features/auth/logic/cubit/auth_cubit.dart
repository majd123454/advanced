import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/features/auth/logic/usecase/login_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

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
}
