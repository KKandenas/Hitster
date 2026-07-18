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
                child: Image.asset('assets/images/spin_wheel.png', fit: BoxFit.contain),
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

