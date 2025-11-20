import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated engine/gear widget for vehicle parts theme
class AnimatedEngineWidget extends StatefulWidget {
  final double size;
  final Color color;
  
  const AnimatedEngineWidget({
    super.key,
    this.size = 80,
    this.color = Colors.white,
  });

  @override
  State<AnimatedEngineWidget> createState() => _AnimatedEngineWidgetState();
}

class _AnimatedEngineWidgetState extends State<AnimatedEngineWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: EnginePainter(
            rotation: _controller.value * 2 * math.pi,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class EnginePainter extends CustomPainter {
  final double rotation;
  final Color color;

  EnginePainter({
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // Draw gear/engine part
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw outer gear teeth
    final gearPath = Path();
    final toothCount = 12;
    final toothDepth = radius * 0.15;

    for (int i = 0; i < toothCount; i++) {
      final angle = (i * 2 * math.pi / toothCount) + rotation;
      final outerRadius = radius;
      final innerRadius = radius - toothDepth;

      final x1 = center.dx + outerRadius * math.cos(angle);
      final y1 = center.dy + outerRadius * math.sin(angle);

      final angle2 = ((i + 0.5) * 2 * math.pi / toothCount) + rotation;
      final x2 = center.dx + innerRadius * math.cos(angle2);
      final y2 = center.dy + innerRadius * math.sin(angle2);

      if (i == 0) {
        gearPath.moveTo(x1, y1);
      } else {
        gearPath.lineTo(x1, y1);
      }
      gearPath.lineTo(x2, y2);
    }
    gearPath.close();

    canvas.drawPath(gearPath, paint);

    // Draw center circle (hub)
    final hubPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, hubPaint);

    // Draw center circle outline
    canvas.drawCircle(center, radius * 0.3, paint);

    // Draw inner details (bolts/screws)
    final boltCount = 4;
    final boltRadius = radius * 0.15;
    for (int i = 0; i < boltCount; i++) {
      final angle = (i * 2 * math.pi / boltCount) + rotation;
      final boltX = center.dx + radius * 0.5 * math.cos(angle);
      final boltY = center.dy + radius * 0.5 * math.sin(angle);
      
      final boltPaint = Paint()
        ..color = color.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(boltX, boltY), boltRadius * 0.3, boltPaint);
    }
  }

  @override
  bool shouldRepaint(EnginePainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.color != color;
  }
}

