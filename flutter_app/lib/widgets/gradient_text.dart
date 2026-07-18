import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Renders [text] filled with the accent gradient — used for every
/// h1.title heading in the web version.
class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;

  const GradientText(
    this.text, {
    super.key,
    required this.fontSize,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.accentGradient.createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

/// The small uppercase "eyebrow" pill shown above page titles.
class EyebrowChip extends StatelessWidget {
  final String label;

  const EyebrowChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent2.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.accent2.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.accent2,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}
