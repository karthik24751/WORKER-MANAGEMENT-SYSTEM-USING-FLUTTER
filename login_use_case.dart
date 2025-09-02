import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String role,
    bool rememberMe = false,
  }) async {
    return await repository.login(
      email: email,
      password: password,
      role: role,
      rememberMe: rememberMe,
    );
  }
}
