import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error occurred',
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Network connection failed',
  }) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred',
  }) : super(message: message);
}

// Authentication specific failures
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    String message = 'Invalid email or password',
  }) : super(message: message);
}

class AccountNotVerifiedFailure extends Failure {
  const AccountNotVerifiedFailure({
    String message = 'Account not verified',
  }) : super(message: message);
}

class AccountLockedFailure extends Failure {
  const AccountLockedFailure({
    String message = 'Account is locked',
  }) : super(message: message);
}

class InvalidRoleFailure extends Failure {
  const InvalidRoleFailure({
    String message = 'Invalid role for this operation',
  }) : super(message: message);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({
    String message = 'Authentication token has expired',
  }) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized access',
  }) : super(message: message);
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = 'Validation failed',
  }) : super(message: message);
}

class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure({
    String message = 'Email already exists',
  }) : super(message: message);
}

// Social login failures
class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure({
    String message = 'Google sign in failed',
  }) : super(message: message);
}

class AppleSignInFailure extends Failure {
  const AppleSignInFailure({
    String message = 'Apple sign in failed',
  }) : super(message: message);
}

class FacebookSignInFailure extends Failure {
  const FacebookSignInFailure({
    String message = 'Facebook sign in failed',
  }) : super(message: message);
}
