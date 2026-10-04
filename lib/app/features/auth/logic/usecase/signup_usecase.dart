import 'package:dartz/dartz.dart';
import 'package:swb_advance/app/features/auth/data/models/user_model.dart';
import 'package:swb_advance/app/features/auth/data/repositories/auth_repo.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      address: address,
    );
  }
}
