import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final String role;

  const AuthAuthenticated({required this.user, required this.role});

  @override
  List<Object> get props => [user, role];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? email;

  const AuthError({required this.message, this.email});

  @override
  List<Object?> get props => [message, email];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class PasswordResetSuccess extends AuthState {}
