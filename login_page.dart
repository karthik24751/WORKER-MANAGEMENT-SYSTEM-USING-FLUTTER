import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/routes/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/role_badge.dart';

class LoginPage extends StatefulWidget {
  final String role;
  
  const LoginPage({
    super.key,
    required this.role,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  
  // Role-based configurations
  late final Map<String, dynamic> _roleConfig;
  
  @override
  void initState() {
    super.initState();
    _initializeRoleConfig();
  }
  
  void _initializeRoleConfig() {
    switch (widget.role.toLowerCase()) {
      case 'worker':
        _roleConfig = {
          'title': 'Worker Login',
          'subtitle': 'Access your work dashboard and manage your tasks',
          'icon': Icons.engineering_rounded,
          'primaryColor': const Color(0xFF4A6CF7),
        };
        break;
      case 'manager':
        _roleConfig = {
          'title': 'Manager Login',
          'subtitle': 'Manage your team and track work progress',
          'icon': Icons.supervisor_account_rounded,
          'primaryColor': const Color(0xFFFF6B6B),
        };
        break;
      case 'user':
      default:
        _roleConfig = {
          'title': 'User Login',
          'subtitle': 'Submit complaints and provide feedback',
          'icon': Icons.person_rounded,
          'primaryColor': const Color(0xFF4CAF50),
        };
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Dispatch login event
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: widget.role,
          rememberMe: _rememberMe,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to dashboard based on role
            switch (state.role) {
              case 'worker':
                AppRouter.goToWorkerDashboard(context);
                break;
              case 'manager':
                AppRouter.goToManagerDashboard(context);
                break;
              case 'general':
                AppRouter.goToGeneralUserDashboard(context);
                break;
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Role badge
                Center(
                  child: RoleBadge(
                    role: widget.role,
                    icon: _roleConfig['icon'],
                    color: _roleConfig['primaryColor'],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  _roleConfig['title'],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 100.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOutQuart,
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  _roleConfig['subtitle'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOutQuart,
                ),
                
                const SizedBox(height: 40),
                
                // Email field
                AuthTextField(
                  controller: _emailController,
                  label: 'Email or Username',
                  prefixIcon: const Icon(Icons.email_rounded),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or username';
                    }
                    // Basic email validation
                    final emailRegex = RegExp(r'^[^@]+@[^\s]+\.[^\s]+$');
                    if (!emailRegex.hasMatch(value) && !value.contains('@')) {
                      return 'Please enter a valid email or username';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 300.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOutQuart,
                ),
                
                const SizedBox(height: 16),
                
                // Password field
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: const Icon(Icons.lock_rounded),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitForm(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOutQuart,
                ),
                
                const SizedBox(height: 8),
                
                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return _roleConfig['primaryColor'];
                              }
                              return theme.colorScheme.surfaceVariant;
                            },
                          ),
                        ),
                        Text(
                          'Remember me',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    
                    // Forgot password
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _roleConfig['primaryColor'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOutQuart,
                ),
                
                const SizedBox(height: 24),
                
                // Login button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AuthLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _roleConfig['primaryColor'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusMedium,
                          ),
                        ),
                        elevation: 4,
                        shadowColor: _roleConfig['primaryColor'].withOpacity(0.3),
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ).animate().fadeIn(delay: 600.ms).slideY(
                  begin: 0.3,
                  end: 0,
                  curve: Curves.easeOutBack,
                ),
                
                if (widget.role.toLowerCase() == 'user') ...[
                  const SizedBox(height: 24),
                  
                  // Sign up section for general users
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to sign up page
                        },
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _roleConfig['primaryColor'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms).slideY(
                    begin: 0.2,
                    end: 0,
                    curve: Curves.easeOutQuart,
                  ),
                ],
                
                const SizedBox(height: 40),
                
                // Social login options
                _buildSocialLoginOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSocialLoginOptions() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Divider with "or" text
        Row(
          children: [
            const Expanded(
              child: Divider(thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
            const Expanded(
              child: Divider(thickness: 1),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Social login buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              onPressed: () {
                // TODO: Implement Google sign in
              },
            ),
            
            const SizedBox(width: 16),
            
            _buildSocialButton(
              icon: Icons.apple_rounded,
              onPressed: () {
                // TODO: Implement Apple sign in
              },
            ),
            
            const SizedBox(width: 16),
            
            _buildSocialButton(
              icon: Icons.facebook_rounded,
              onPressed: () {
                // TODO: Implement Facebook sign in
              },
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 800.ms).slideY(
      begin: 0.2,
      end: 0,
      curve: Curves.easeOutQuart,
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 28,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
