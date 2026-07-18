import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NavBarAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool accent;

  const NavBarAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.accent = false,
  });
}

/// Pill-shaped navigation row shown at the top of every screen except
/// the home menu — equivalent to the web version's `.nav-bar`.
class AppNavBar extends StatelessWidget {
  final List<NavBarAction> actions;
  final double maxWidth;

  const AppNavBar({super.key, required this.actions, this.maxWidth = 440});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final action in actions) _NavPill(action: action),
        ],
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final NavBarAction action;

  const _NavPill({required this.action});

  @override
  Widget build(BuildContext context) {
    final borderColor = action.accent
        ? AppColors.accent1.withValues(alpha: 0.6)
        : AppColors.surfaceHairline;
    final textColor = action.accent ? const Color(0xFFFFE1EF) : AppColors.textPrimary;

    return Material(
      color: action.accent
          ? AppColors.accent1.withValues(alpha: 0.14)
          : Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(action.icon, size: 15, color: textColor),
              const SizedBox(width: 6),
              Text(
                action.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
