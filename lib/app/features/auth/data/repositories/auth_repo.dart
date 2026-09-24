import 'package:dartz/dartz.dart';

import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  });
}
