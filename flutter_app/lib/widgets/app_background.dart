import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen gradient backdrop with a few soft glow blobs, mirroring
/// the radial-gradient page background from the web version's style.css.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.bg1, AppColors.bg2, AppColors.bg3],
            ),
          ),
        ),
        _glow(alignment: const Alignment(-0.8, -0.9), color: AppColors.accent1, size: 420),
        _glow(alignment: const Alignment(0.9, 0.9), color: AppColors.accent2, size: 460),
        _glow(alignment: const Alignment(0, 1.1), color: AppColors.accentMid, size: 520),
        child,
      ],
    );
  }

  Widget _glow({
    required Alignment alignment,
    required Color color,
    required double size,
  }) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.18),
          ),
        ),
      ),
    );
  }
}
