import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../app/theme/app_theme.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Select Your Role'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Header
                Text(
                  'Choose Your Role',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
                
                const SizedBox(height: 8),
                
                Text(
                  'Select the role that best describes you',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                
                const SizedBox(height: 40),
                
                // Role cards
                _buildRoleCard(
                  role: 'worker',
                  title: 'Worker',
                  subtitle: 'Track attendance, view tasks, and communicate with team',
                  icon: Icons.engineering,
                  color: Colors.blue,
                  features: [
                    'Clock in/out with location',
                    'View assigned tasks',
                    'Team chat and updates',
                    'Submit reports',
                  ],
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: -0.3),
                
                const SizedBox(height: 20),
                
                _buildRoleCard(
                  role: 'manager',
                  title: 'Manager',
                  subtitle: 'Manage team, assign tasks, and monitor progress',
                  icon: Icons.supervisor_account,
                  color: Colors.green,
                  features: [
                    'Team management',
                    'Task assignment',
                    'Attendance monitoring',
                    'Performance analytics',
                  ],
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideX(begin: 0.3),
                
                const SizedBox(height: 20),
                
                _buildRoleCard(
                  role: 'general',
                  title: 'General User',
                  subtitle: 'Submit complaints, feedback, and service requests',
                  icon: Icons.person,
                  color: Colors.orange,
                  features: [
                    'Submit complaints',
                    'Service requests',
                    'Feedback system',
                    'Track request status',
                  ],
                ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideX(begin: -0.3),
                
                const SizedBox(height: 40),
                
                // Continue button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: selectedRole != null
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _continueWithRole(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                              ),
                            ),
                            child: Text(
                              'Continue as ${_getRoleDisplayName(selectedRole!)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3)
                      : const SizedBox.shrink(),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<String> features,
  }) {
    final theme = Theme.of(context);
    final isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(AppTheme.paddingLarge),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withOpacity(0.1) 
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(
            color: isSelected 
                ? color 
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? color 
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : color,
                    size: 28,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected 
                              ? color 
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isSelected ? 0.25 : 0,
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? color : theme.colorScheme.outline,
                    size: 24,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Features list
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features.map((feature) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? color.withOpacity(0.2) 
                      : theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Text(
                  feature,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected 
                        ? color 
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'worker':
        return 'Worker';
      case 'manager':
        return 'Manager';
      case 'general':
        return 'General User';
      default:
        return 'User';
    }
  }

  void _continueWithRole(BuildContext context) {
    if (selectedRole != null) {
      AppRouter.goToLogin(context, selectedRole!);
    }
  }
}
