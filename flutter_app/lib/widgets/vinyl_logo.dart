import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A hand-painted vinyl record mark used as the app's logo and as the
/// spinning icon on the shuffle button. Pure CustomPainter — no image
/// assets or network fonts/icons required.
class VinylLogo extends StatelessWidget {
  final double size;
  final bool spin;
  final Duration spinDuration;

  const VinylLogo({
    super.key,
    this.size = 108,
    this.spin = true,
    this.spinDuration = const Duration(seconds: 16),
  });

  @override
  Widget build(BuildContext context) {
    final painter = _VinylPainter();

    if (!spin) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: painter),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: _InfiniteSpin(duration: spinDuration, painter: painter),
    );
  }
}

class _InfiniteSpin extends StatefulWidget {
  final Duration duration;
  final CustomPainter painter;

  const _InfiniteSpin({required this.duration, required this.painter});

  @override
  State<_InfiniteSpin> createState() => _InfiniteSpinState();
}

class _InfiniteSpinState extends State<_InfiniteSpin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: CustomPaint(painter: widget.painter),
    );
  }
}

class _VinylPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2;

    final ringGradient = SweepGradient(
      colors: const [
        AppColors.accent1,
        AppColors.accentMid,
        AppColors.accent2,
        AppColors.accent1,
      ],
      startAngle: 0,
      endAngle: 2 * math.pi,
    );

    canvas.drawCircle(center, r * 0.98, Paint()..color = AppColors.bg1);

    canvas.drawCircle(
      center,
      r * 0.96,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.04
        ..shader = ringGradient.createShader(
          Rect.fromCircle(center: center, radius: r),
        ),
    );

    final groovePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.02
      ..color = Colors.white.withValues(alpha: 0.1);
    for (final f in [0.76, 0.6, 0.44]) {
      canvas.drawCircle(center, r * f, groovePaint);
    }

    final labelGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [AppColors.accent1, AppColors.accent2],
    );
    canvas.drawCircle(
      center,
      r * 0.3,
      Paint()
        ..shader = labelGradient.createShader(
          Rect.fromCircle(center: center, radius: r * 0.3),
        ),
    );

    canvas.drawCircle(center, r * 0.08, Paint()..color = AppColors.bg1);
  }

  @override
  bool shouldRepaint(covariant _VinylPainter oldDelegate) => false;
}
