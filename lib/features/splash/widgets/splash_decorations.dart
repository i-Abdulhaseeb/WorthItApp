import 'package:flutter/material.dart';

/// Custom background painter for the ambient green glows and curved organic lines.
class SplashBackgroundPainter extends CustomPainter {
  const SplashBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Top-Right Ambient Glow
    final topRightGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD8EBE0).withValues(alpha: 0.75),
          const Color(0xFFEAF5EE).withValues(alpha: 0.35),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.98, size.height * 0.05),
          radius: size.width * 0.55,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.98, size.height * 0.05),
      size.width * 0.55,
      topRightGlowPaint,
    );

    // 2. Top-Right Curved Line
    final linePaint = Paint()
      ..color = const Color(0xFF8FB3A0).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..isAntiAlias = true;

    final topRightPath = Path();
    topRightPath.moveTo(size.width * 0.60, 0);
    topRightPath.cubicTo(
      size.width * 0.70,
      size.height * 0.05,
      size.width * 0.85,
      size.height * 0.08,
      size.width,
      size.height * 0.16,
    );
    canvas.drawPath(topRightPath, linePaint);

    // 3. Center Arch Glow behind Logo
    final centerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD6ECE0).withValues(alpha: 0.55),
          const Color(0xFFE4F3EB).withValues(alpha: 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.32),
          radius: size.width * 0.42,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.32),
      size.width * 0.42,
      centerGlowPaint,
    );

    // 4. Bottom-Left Ambient Glow
    final bottomLeftGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD8EBE0).withValues(alpha: 0.75),
          const Color(0xFFEAF5EE).withValues(alpha: 0.35),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.02, size.height * 0.94),
          radius: size.width * 0.58,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.02, size.height * 0.94),
      size.width * 0.58,
      bottomLeftGlowPaint,
    );

    // 5. Bottom-Left Curved Line
    final bottomLeftPath = Path();
    bottomLeftPath.moveTo(0, size.height * 0.88);
    bottomLeftPath.cubicTo(
      size.width * 0.15,
      size.height * 0.93,
      size.width * 0.22,
      size.height * 0.96,
      size.width * 0.36,
      size.height,
    );
    canvas.drawPath(bottomLeftPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the two-leaf sprout between the bottom divider.
class LeafSproutPainter extends CustomPainter {
  final Color color;

  const LeafSproutPainter({this.color = const Color(0xFF007A4D)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left leaf
    final leftPath = Path();
    leftPath.moveTo(size.width * 0.5, size.height * 0.85);
    leftPath.quadraticBezierTo(
      size.width * 0.05,
      size.height * 0.55,
      size.width * 0.18,
      size.height * 0.12,
    );
    leftPath.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.85,
    );
    canvas.drawPath(leftPath, paint);

    // Right leaf
    final rightPath = Path();
    rightPath.moveTo(size.width * 0.5, size.height * 0.85);
    rightPath.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.55,
      size.width * 0.82,
      size.height * 0.12,
    );
    rightPath.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.85,
    );
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
