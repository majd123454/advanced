import 'package:dartz/dartz.dart';

import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<String, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
  });
}
