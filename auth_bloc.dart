import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Timer? _authTimer;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<FacebookSignInRequested>(_onFacebookSignInRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Please fill in all fields'));
        return;
      }

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email'));
        return;
      }

      if (event.password.length < 6) {
        emit(const AuthError(message: 'Password must be at least 6 characters'));
        return;
      }

      // Mock successful login
      final user = UserEntity(
        id: '1',
        name: 'John Doe',
        email: event.email,
        role: event.role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      emit(AuthAuthenticated(user: user, role: event.role));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (event.name.isEmpty || event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Please fill in all fields'));
        return;
      }

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email'));
        return;
      }

      if (event.password.length < 6) {
        emit(const AuthError(message: 'Password must be at least 6 characters'));
        return;
      }

      // Mock successful signup
      final user = UserEntity(
        id: '1',
        name: event.name,
        email: event.email,
        role: event.role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      emit(AuthAuthenticated(user: user, role: event.role));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _cancelAuthTimer();
    emit(AuthLoading());
    
    try {
      // Simulate logout delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Simulate checking stored auth token
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For now, always return unauthenticated
      // In real app, check stored token/session
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email'));
        return;
      }

      emit(ForgotPasswordSuccess(
        message: 'Password reset link sent to ${event.email}',
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthError(message: 'Google sign in not implemented yet'));
    } catch (e) {
      emit(AuthError(message: 'Google sign in failed. Please try again.'));
    }
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthError(message: 'Apple sign in not implemented yet'));
    } catch (e) {
      emit(AuthError(message: 'Apple sign in failed. Please try again.'));
    }
  }

  Future<void> _onFacebookSignInRequested(
    FacebookSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthError(message: 'Facebook sign in not implemented yet'));
    } catch (e) {
      emit(AuthError(message: 'Facebook sign in failed. Please try again.'));
    }
  }

  void _startAuthTimer() {
    _cancelAuthTimer();
    _authTimer = Timer(const Duration(hours: 24), () {
      add(LogoutRequested());
    });
  }

  void _cancelAuthTimer() {
    _authTimer?.cancel();
    _authTimer = null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Future<void> close() {
    _cancelAuthTimer();
    return super.close();
  }
}
