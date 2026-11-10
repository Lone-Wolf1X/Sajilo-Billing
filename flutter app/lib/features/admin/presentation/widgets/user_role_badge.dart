import 'package:flutter/material.dart';

class UserRoleBadge extends StatelessWidget {
  final String role;
  const UserRoleBadge({super.key, required this.role});

  static const _colors = <String, Color>{
    'ADMIN': Color(0xFF7A2E2E), // maroon
    'ACCOUNTANT': Color(0xFF1E3A5F), // navy
    'CASHIER': Color(0xFF2D6A4F), // forest
    'VIEWER': Color(0xFF6B6B62), // muted
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[role] ?? const Color(0xFF6B6B62);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

