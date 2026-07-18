import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Which hand-drawn glyph represents a challenge category. Kept separate
/// from [Challenge] itself so the drawing code has a closed, exhaustive
/// set to switch over.
enum ChallengeGlyph { yearTight, yearWide, decade, millennium, artist }

/// Paints a small custom vector icon for [glyph], centered at [center]
/// with an overall size driven by [radius]. Used directly on a Canvas by
/// the spin wheel, and wrapped in [ChallengeGlyphIcon] for use as a
/// regular widget (e.g. on the result card) — one drawing routine, two
/// call sites, so the wheel and the reveal always match.
void paintChallengeGlyph(
  Canvas canvas,
  ChallengeGlyph glyph,
  Offset center,
  double radius,
  Color color,
) {
  switch (glyph) {
    case ChallengeGlyph.yearTight:
      _paintCalendar(canvas, center, radius, color, highlightSpan: 1);
    case ChallengeGlyph.yearWide:
      _paintCalendar(canvas, center, radius, color, highlightSpan: 3);
    case ChallengeGlyph.decade:
      _paintDecadeDial(canvas, center, radius, color);
    case ChallengeGlyph.millennium:
      _paintMillenniumSplit(canvas, center, radius, color);
    case ChallengeGlyph.artist:
      _paintMicrophone(canvas, center, radius, color);
  }
}

/// Widget form of [paintChallengeGlyph], for places (like the result
/// card) that need the glyph as an ordinary widget rather than painted
/// straight onto an existing canvas.
class ChallengeGlyphIcon extends StatelessWidget {
  final ChallengeGlyph glyph;
  final Color color;
  final double size;

  const ChallengeGlyphIcon({super.key, required this.glyph, required this.color, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GlyphPainter(glyph, color)),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  final ChallengeGlyph glyph;
  final Color color;

  _GlyphPainter(this.glyph, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    paintChallengeGlyph(canvas, glyph, size.center(Offset.zero), size.width / 2, color);
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}

Paint _stroke(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

void _paintCalendar(Canvas canvas, Offset c, double r, Color color, {required int highlightSpan}) {
  final sw = r * 0.16;
  final bodyRect = Rect.fromCenter(center: c.translate(0, r * 0.08), width: r * 1.7, height: r * 1.5);
  final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(r * 0.22));

  canvas.drawRRect(bodyRRect, _stroke(color, sw));

  final headerY = bodyRect.top + r * 0.42;
  canvas.drawLine(Offset(bodyRect.left, headerY), Offset(bodyRect.right, headerY), _stroke(color, sw * 0.8));

  for (final dx in [-0.45, 0.45]) {
    canvas.drawLine(
      Offset(c.dx + dx * r, bodyRect.top - r * 0.16),
      Offset(c.dx + dx * r, bodyRect.top + r * 0.14),
      _stroke(color, sw * 0.9),
    );
  }

  const cellCount = 5;
  final rowY = bodyRect.bottom - r * 0.38;
  final rowWidth = bodyRect.width * 0.72;
  final cellSize = rowWidth / cellCount * 0.68;
  final gap = rowWidth / cellCount;
  final startX = c.dx - rowWidth / 2 + gap / 2;
  final firstHighlighted = (cellCount - highlightSpan) ~/ 2;

  for (var i = 0; i < cellCount; i++) {
    final cellCenter = Offset(startX + i * gap, rowY);
    final cellRect = Rect.fromCenter(center: cellCenter, width: cellSize, height: cellSize);
    final isHighlighted = i >= firstHighlighted && i < firstHighlighted + highlightSpan;
    final cellRRect = RRect.fromRectAndRadius(cellRect, Radius.circular(cellSize * 0.3));
    if (isHighlighted) {
      canvas.drawRRect(cellRRect, Paint()..color = color);
    } else {
      canvas.drawRRect(cellRRect, _stroke(color, sw * 0.55));
    }
  }
}

void _paintDecadeDial(Canvas canvas, Offset c, double r, Color color) {
  final sw = r * 0.16;
  final faceRadius = r * 0.85;
  canvas.drawCircle(c, faceRadius, _stroke(color, sw));

  for (final angleDeg in [0, 90, 180, 270]) {
    final a = angleDeg * math.pi / 180;
    final outer = Offset(c.dx + faceRadius * math.cos(a), c.dy + faceRadius * math.sin(a));
    final inner = Offset(c.dx + faceRadius * 0.78 * math.cos(a), c.dy + faceRadius * 0.78 * math.sin(a));
    canvas.drawLine(inner, outer, _stroke(color, sw * 0.85));
  }

  final handAngle = -2.4;
  canvas.drawLine(
    c,
    Offset(c.dx + faceRadius * 0.55 * math.cos(handAngle), c.dy + faceRadius * 0.55 * math.sin(handAngle)),
    _stroke(color, sw * 0.8),
  );
  canvas.drawLine(c, Offset(c.dx, c.dy - faceRadius * 0.5), _stroke(color, sw * 0.8));
  canvas.drawCircle(c, sw * 0.55, Paint()..color = color);
}

void _paintMillenniumSplit(Canvas canvas, Offset c, double r, Color color) {
  final sw = r * 0.16;
  final faceRadius = r * 0.85;

  final leftHalf = Path()
    ..moveTo(c.dx, c.dy - faceRadius)
    ..arcTo(Rect.fromCircle(center: c, radius: faceRadius), -1.5708, -3.1416, false)
    ..close();
  canvas.drawPath(leftHalf, Paint()..color = color);

  canvas.drawCircle(c, faceRadius, _stroke(color, sw));
  canvas.drawLine(Offset(c.dx, c.dy - faceRadius), Offset(c.dx, c.dy + faceRadius), _stroke(color, sw * 0.7));
}

void _paintMicrophone(Canvas canvas, Offset c, double r, Color color) {
  final sw = r * 0.16;
  final capsuleRect = Rect.fromCenter(center: c.translate(0, -r * 0.28), width: r * 0.62, height: r * 1.0);
  canvas.drawRRect(RRect.fromRectAndRadius(capsuleRect, Radius.circular(r * 0.31)), _stroke(color, sw));

  for (final dy in [-0.42, -0.14, 0.14]) {
    canvas.drawLine(
      Offset(capsuleRect.left + capsuleRect.width * 0.18, capsuleRect.top + capsuleRect.height * (0.5 + dy)),
      Offset(capsuleRect.right - capsuleRect.width * 0.18, capsuleRect.top + capsuleRect.height * (0.5 + dy)),
      _stroke(color, sw * 0.55),
    );
  }

  final standRect = Rect.fromCenter(center: c.translate(0, r * 0.06), width: r * 1.15, height: r * 1.0);
  canvas.drawArc(standRect, 0.35, 3.1416 - 0.7, false, _stroke(color, sw * 0.85));
  canvas.drawLine(c.translate(0, r * 0.55), c.translate(0, r * 0.85), _stroke(color, sw * 0.85));
  canvas.drawLine(c.translate(-r * 0.28, r * 0.85), c.translate(r * 0.28, r * 0.85), _stroke(color, sw * 0.85));
}
