import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/auth/data/models/user_model.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<String, UserEntity>> call(String email, String password) async {
    return await repository.signIn(email: email, password: password);
  }
}
