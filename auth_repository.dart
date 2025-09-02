import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  // User authentication
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required String role,
    bool rememberMe = false,
  });
  
  Future<Either<Failure, void>> logout();
  
  // Token management
  Future<Either<Failure, String>> getAccessToken();
  Future<Either<Failure, String>> getRefreshToken();
  Future<Either<Failure, void>> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  
  // User session
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> cacheUser(UserEntity user);
  
  // Password reset
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });
  
  // Email verification
  Future<Either<Failure, void>> sendVerificationEmail();
  Future<Either<Failure, void>> verifyEmail(String token);
  
  // Social login
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, UserEntity>> loginWithApple();
  Future<Either<Failure, UserEntity>> loginWithFacebook();
}
