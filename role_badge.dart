import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  final IconData icon;
  final Color color;
  final double size;
  final bool showLabel;
  final bool animate;
  
  const RoleBadge({
    super.key,
    required this.role,
    required this.icon,
    required this.color,
    this.size = 80.0,
    this.showLabel = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayRole = _formatRoleName(role);
    
    Widget badge = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon container with gradient background
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                Color.lerp(color, Colors.black, 0.2)!,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
        
        if (showLabel) ...[
          const SizedBox(height: 12),
          // Role label with background
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              displayRole,
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
    
    // Apply animations if enabled
    if (animate) {
      return badge.animate(
        onPlay: (controller) => controller.repeat(),
      ).shimmer(
        duration: 2000.ms,
        delay: 1000.ms,
        size: 0.2,
      );
    }
    
    return badge;
  }
  
  String _formatRoleName(String role) {
    switch (role.toLowerCase()) {
      case 'worker':
        return 'Worker';
      case 'manager':
        return 'Manager';
      case 'user':
        return 'General User';
      default:
        return role;
    }
  }
}
