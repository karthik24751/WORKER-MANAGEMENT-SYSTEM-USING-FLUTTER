import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _isAuthenticatedKey = 'is_authenticated';

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required String role,
    bool rememberMe = false,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication logic
      if (email == 'test@example.com' && password == 'Test123!') {
        final user = UserEntity.create(
          id: const Uuid().v4(),
          email: email,
          name: 'Test User',
          role: role,
          isEmailVerified: true,
          lastLoginAt: DateTime.now(),
        );

        // Save tokens and user data
        await saveTokens(
          accessToken: 'mock_access_token_${user.id}',
          refreshToken: 'mock_refresh_token_${user.id}',
        );
        await cacheUser(user);
        await sharedPreferences.setBool(_isAuthenticatedKey, true);

        return Right(user);
      } else {
        return const Left(InvalidCredentialsFailure());
      }
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await sharedPreferences.remove(_accessTokenKey);
      await sharedPreferences.remove(_refreshTokenKey);
      await sharedPreferences.remove(_userDataKey);
      await sharedPreferences.setBool(_isAuthenticatedKey, false);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getAccessToken() async {
    try {
      final token = sharedPreferences.getString(_accessTokenKey);
      if (token != null) {
        return Right(token);
      } else {
        return const Left(TokenExpiredFailure());
      }
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getRefreshToken() async {
    try {
      final token = sharedPreferences.getString(_refreshTokenKey);
      if (token != null) {
        return Right(token);
      } else {
        return const Left(TokenExpiredFailure());
      }
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await sharedPreferences.setString(_accessTokenKey, accessToken);
      await sharedPreferences.setString(_refreshTokenKey, refreshToken);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = sharedPreferences.getBool(_isAuthenticatedKey) ?? false;
      final token = sharedPreferences.getString(_accessTokenKey);
      return Right(isAuth && token != null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userDataJson = sharedPreferences.getString(_userDataKey);
      if (userDataJson != null) {
        // In a real app, you would deserialize JSON to UserEntity
        // For now, return a mock user
        final user = UserEntity.create(
          id: 'mock_user_id',
          email: 'test@example.com',
          name: 'Test User',
          role: 'worker',
        );
        return Right(user);
      }
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cacheUser(UserEntity user) async {
    try {
      // In a real app, you would serialize UserEntity to JSON
      await sharedPreferences.setString(_userDataKey, user.toString());
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationEmail() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      // Simulate Google sign in
      await Future.delayed(const Duration(seconds: 2));
      return const Left(GoogleSignInFailure());
    } catch (e) {
      return const Left(GoogleSignInFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithApple() async {
    try {
      // Simulate Apple sign in
      await Future.delayed(const Duration(seconds: 2));
      return const Left(AppleSignInFailure());
    } catch (e) {
      return const Left(AppleSignInFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithFacebook() async {
    try {
      // Simulate Facebook sign in
      await Future.delayed(const Duration(seconds: 2));
      return const Left(FacebookSignInFailure());
    } catch (e) {
      return const Left(FacebookSignInFailure());
    }
  }
}
