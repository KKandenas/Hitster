import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/challenges.dart';
import '../theme/app_colors.dart';

/// A five-slice prize wheel — one slice per [Challenge] — used by the
/// generator screen. [rotation] is in radians and is expected to be
/// driven by an external AnimationController so the wheel can spin to
/// land on a chosen challenge.
class SpinWheel extends StatelessWidget {
  final double rotation;
  final double size;

  const SpinWheel({super.key, required this.rotation, this.size = 240});

  static const sliceAngle = 2 * math.pi / 5;

  /// The rotation (mod 2π) that brings challenge [index]'s slice under
  /// the fixed pointer at the top of the wheel.
  static double targetRotationFor(int index) {
    final raw = -(index + 0.5) * sliceAngle;
    final twoPi = 2 * math.pi;
    return ((raw % twoPi) + twoPi) % twoPi;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 18,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 18,
            child: Transform.rotate(
              angle: rotation,
              child: SizedBox(
                width: size,
                height: size,
                child: CustomPaint(painter: _WheelPainter()),
              ),
            ),
          ),
          const Positioned(top: 4, child: _Pointer()),
        ],
      ),
    );
  }
}

class _Pointer extends StatelessWidget {
  const _Pointer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(26, 22),
      painter: _PointerPainter(),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accent1
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _PointerPainter oldDelegate) => false;
}

class _WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2;
    const sliceAngle = SpinWheel.sliceAngle;
    // Slice i spans [startOffset + i*sliceAngle, startOffset + (i+1)*sliceAngle),
    // so its center sits at startOffset + (i+0.5)*sliceAngle — this must match
    // the center angle assumed by [SpinWheel.targetRotationFor].
    const startOffset = -math.pi / 2;

    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    for (var i = 0; i < challenges.length; i++) {
      final start = startOffset + i * sliceAngle;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = challenges[i].farg;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.96),
        start,
        sliceAngle,
        true,
        paint,
      );

      final iconAngle = start + sliceAngle / 2;
      final iconOffset = Offset(
        center.dx + math.cos(iconAngle) * r * 0.62,
        center.dy + math.sin(iconAngle) * r * 0.62,
      );
      _paintIcon(canvas, challenges[i].ikon, iconOffset, r * 0.16);
    }

    final dividerPaint = Paint()
      ..color = AppColors.bg1.withValues(alpha: 0.55)
      ..strokeWidth = r * 0.02
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < challenges.length; i++) {
      final a = startOffset + i * sliceAngle;
      canvas.drawLine(
        center,
        Offset(center.dx + math.cos(a) * r * 0.96, center.dy + math.sin(a) * r * 0.96),
        dividerPaint,
      );
    }

    canvas.drawCircle(
      center,
      r * 0.98,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.045
        ..shader = const SweepGradient(
          colors: [AppColors.accent1, AppColors.accentMid, AppColors.accent2, AppColors.accent1],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    final hubGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.accent1, AppColors.accent2],
    ).createShader(Rect.fromCircle(center: center, radius: r * 0.16));
    canvas.drawCircle(center, r * 0.16, Paint()..color = AppColors.bg1);
    canvas.drawCircle(
      center,
      r * 0.13,
      Paint()..shader = hubGradient,
    );
    canvas.drawCircle(center, r * 0.045, Paint()..color = AppColors.bg1);
  }

  void _paintIcon(Canvas canvas, IconData icon, Offset offset, double fontSize) {
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: const Color(0xFF1A0B14),
        ),
      ),
    )..layout();
    painter.paint(canvas, offset.translate(-painter.width / 2, -painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => false;
}
