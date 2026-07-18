import 'package:flutter/material.dart';

/// Central "Neon Vinyl" color palette, mirrored from the original web
/// app's style.css so both versions stay visually in sync.
class AppColors {
  AppColors._();

  static const bg1 = Color(0xFF0C0A1F);
  static const bg2 = Color(0xFF1A1440);
  static const bg3 = Color(0xFF2A0F3D);

  static const surface = Color(0xB8161230);
  static const surfaceSolid = Color(0xFF171331);
  static const surfaceHairline = Color(0x18FFFFFF);

  static const textPrimary = Color(0xFFF5F3FF);
  static const textMuted = Color(0xFFB3AED6);
  static const textFaint = Color(0xFF837DA8);

  static const accent1 = Color(0xFFFF2E88);
  static const accentMid = Color(0xFFA855F7);
  static const accent2 = Color(0xFF22D3EE);

  // Challenge category colors — kept consistent across generator, bingo
  // grid and rules legend.
  static const cAr2 = Color(0xFFE63946); // Röd — Årtal ± 2 år
  static const cAr4 = Color(0xFF3B9EFF); // Blå — Årtal ± 4 år
  static const cArtionde = Color(0xFF6B21A8); // Lila — Årtionde
  static const cSekel = Color(0xFF2FE0A8); // Grön — Före/efter 2000
  static const cArtist = Color(0xFFFFD166); // Gul — Artist

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent1, accentMid, accent2],
  );

  static LinearGradient accentGradientSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent1.withValues(alpha: 0.18), accent2.withValues(alpha: 0.18)],
  );
}
