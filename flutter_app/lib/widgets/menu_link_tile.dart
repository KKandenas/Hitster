import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// One row on the home screen menu (Slumpgenerator / Bingobricka /
/// Spelinstruktioner) — mirrors the web version's `.menu-link`.
class MenuLinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;
  final bool primary;

  const MenuLinkTile({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeGradient = primary ? AppColors.accentGradient : null;
    final badgeColor = primary ? null : Colors.white.withValues(alpha: 0.08);
    final iconColor = primary ? const Color(0xFF1A0B14) : AppColors.textPrimary;

    return Material(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceHairline),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: badgeGradient,
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
