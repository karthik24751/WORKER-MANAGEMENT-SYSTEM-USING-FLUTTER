import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Triggered when the user attempts to log in
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final bool rememberMe;

  const LoginRequested({
    required this.email,
    required this.password,
    required this.role,
    this.rememberMe = false,
  });

  @override
  List<Object> get props => [email, password, role, rememberMe];
}

// Triggered when the user signs up
class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [name, email, password, role];
}

// Triggered when the user logs out
class LogoutRequested extends AuthEvent {}

// Triggered when the app starts to check if the user is already authenticated
class CheckAuthenticationStatus extends AuthEvent {}

// Triggered when the user requests a password reset
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

// Triggered when the user resets their password
class ResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  const ResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object> get props => [token, newPassword];
}

// Triggered when the user wants to log in with Google
class GoogleSignInRequested extends AuthEvent {}

// Triggered when the user wants to log in with Apple
class AppleSignInRequested extends AuthEvent {}

// Triggered when the user wants to log in with Facebook
class FacebookSignInRequested extends AuthEvent {}

// Triggered when the authentication status changes
class AuthenticationStatusChanged extends AuthEvent {
  final bool isAuthenticated;

  const AuthenticationStatusChanged({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}
