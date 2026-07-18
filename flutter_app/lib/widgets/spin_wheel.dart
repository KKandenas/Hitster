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
          const Positioned(top: 2, child: _Pointer()),
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
      size: const Size(28, 26),
      painter: _PointerPainter(),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(1, 1)
      ..lineTo(size.width - 1, 1)
      ..lineTo(size.width / 2, size.height - 3)
      ..close();

    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF6FAE), AppColors.accent1],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    // Tiny glossy highlight dot near the top tip.
    canvas.drawCircle(
      Offset(size.width * 0.32, size.height * 0.28),
      size.width * 0.06,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
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

    // Soft drop shadow under the whole wheel.
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    for (var i = 0; i < challenges.length; i++) {
      final start = startOffset + i * sliceAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.96),
        start,
        sliceAngle,
        true,
        Paint()
          ..style = PaintingStyle.fill
          ..color = challenges[i].farg,
      );
    }

    final dividerPaint = Paint()
      ..color = AppColors.bg1.withValues(alpha: 0.4)
      ..strokeWidth = r * 0.015
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < challenges.length; i++) {
      final a = startOffset + i * sliceAngle;
      canvas.drawLine(
        center,
        Offset(center.dx + math.cos(a) * r * 0.96, center.dy + math.sin(a) * r * 0.96),
        dividerPaint,
      );
    }

    // Glassy highlight + soft vignette, clipped to the wheel face, so the
    // slices read as a lit, slightly convex surface instead of flat color.
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: r * 0.96)));
    canvas.drawRect(
      Rect.fromCircle(center: center, radius: r),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.5),
          radius: 0.9,
          colors: [Colors.white.withValues(alpha: 0.32), Colors.white.withValues(alpha: 0.0)],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
    canvas.drawRect(
      Rect.fromCircle(center: center, radius: r),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.2, 0.6),
          radius: 0.85,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.22)],
          stops: const [0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
    canvas.restore();

    for (var i = 0; i < challenges.length; i++) {
      final start = startOffset + i * sliceAngle;
      final iconAngle = start + sliceAngle / 2;
      final iconOffset = Offset(
        center.dx + math.cos(iconAngle) * r * 0.6,
        center.dy + math.sin(iconAngle) * r * 0.6,
      );
      _paintIconBadge(canvas, challenges[i], iconOffset, r);
    }

    for (var i = 0; i < challenges.length; i++) {
      final a = startOffset + i * sliceAngle;
      final pinCenter = Offset(center.dx + math.cos(a) * r * 0.96, center.dy + math.sin(a) * r * 0.96);
      _paintPin(canvas, pinCenter, r * 0.05);
    }

    canvas.drawCircle(
      center,
      r * 0.98,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.05
        ..shader = const SweepGradient(
          colors: [AppColors.accent1, AppColors.accentMid, AppColors.accent2, AppColors.accent1],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    _paintHub(canvas, center, r);
  }

  void _paintIconBadge(Canvas canvas, Challenge challenge, Offset offset, double r) {
    final badgeRadius = r * 0.15;
    canvas.drawCircle(
      offset.translate(0, badgeRadius * 0.12),
      badgeRadius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(offset, badgeRadius, Paint()..color = Colors.white.withValues(alpha: 0.95));
    canvas.drawCircle(
      offset,
      badgeRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = badgeRadius * 0.1
        ..color = challenge.farg.withValues(alpha: 0.4),
    );
    _paintIcon(canvas, challenge.ikon, offset, r * 0.155, challenge.farg);
  }

  void _paintPin(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.drawCircle(
      center.translate(0, -radius * 0.18),
      radius * 0.88,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.5),
          colors: const [Colors.white, Color(0xFFC7CCE0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center,
      radius * 0.88,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.22
        ..color = Colors.black.withValues(alpha: 0.18),
    );
  }

  void _paintHub(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(
      center,
      r * 0.2,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(center, r * 0.18, Paint()..color = AppColors.bg1);
    canvas.drawCircle(
      center,
      r * 0.155,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.012
        ..color = Colors.white.withValues(alpha: 0.18),
    );
    canvas.drawCircle(
      center,
      r * 0.135,
      Paint()
        ..shader = const SweepGradient(
          colors: [AppColors.accent1, AppColors.accentMid, AppColors.accent2, AppColors.accent1],
        ).createShader(Rect.fromCircle(center: center, radius: r * 0.135)),
    );
    canvas.drawCircle(
      center,
      r * 0.1,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent1, AppColors.accent2],
        ).createShader(Rect.fromCircle(center: center, radius: r * 0.1)),
    );
    // Glossy highlight arc, like light catching a domed cap.
    canvas.drawArc(
      Rect.fromCircle(center: center.translate(-r * 0.03, -r * 0.03), radius: r * 0.075),
      math.pi * 1.05,
      math.pi * 0.55,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.02
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.55),
    );
    canvas.drawCircle(center, r * 0.045, Paint()..color = AppColors.bg1);
  }

  void _paintIcon(Canvas canvas, IconData icon, Offset offset, double fontSize, Color color) {
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
    )..layout();
    painter.paint(canvas, offset.translate(-painter.width / 2, -painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => false;
}
