import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The primary call-to-action button (shuffle, regenerate bingo card).
/// [child] should style its own Text/Icon widgets using [onDark] (near-black,
/// used on top of the bright gradient fill).
class GradientButton extends StatelessWidget {
  static const onDark = Color(0xFF1A0B14);

  final Widget child;
  final VoidCallback? onPressed;

  const GradientButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent1.withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
