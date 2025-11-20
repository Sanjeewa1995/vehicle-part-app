import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated engine/vehicle parts widget to make the app visually appealing
/// and clearly indicate it's a vehicle spare parts app
class AnimatedEngineWidget extends StatefulWidget {
  final double size;
  final Color? color;

  const AnimatedEngineWidget({
    super.key,
    this.size = 120,
    this.color,
  });

  @override
  State<AnimatedEngineWidget> createState() => _AnimatedEngineWidgetState();
}

class _AnimatedEngineWidgetState extends State<AnimatedEngineWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _EnginePainter(
              rotation: _rotationAnimation.value,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class _EnginePainter extends CustomPainter {
  final double rotation;
  final Color color;

  _EnginePainter({
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // Save canvas state
    canvas.save();
    
    // Rotate around center
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw engine block (main rectangle)
    final blockRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: radius * 1.2,
        height: radius * 0.8,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(blockRect, fillPaint);
    canvas.drawRRect(blockRect, paint);

    // Draw pistons (circles)
    final pistonRadius = radius * 0.15;
    final pistonOffset = radius * 0.4;
    
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi * 2) / 4;
      final pistonCenter = Offset(
        center.dx + math.cos(angle) * pistonOffset,
        center.dy + math.sin(angle) * pistonOffset,
      );
      
      canvas.drawCircle(pistonCenter, pistonRadius, fillPaint);
      canvas.drawCircle(pistonCenter, pistonRadius, paint);
      
      // Draw connecting rods
      final rodPaint = Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawLine(
        pistonCenter,
        Offset(
          center.dx + math.cos(angle) * pistonOffset * 0.3,
          center.dy + math.sin(angle) * pistonOffset * 0.3,
        ),
        rodPaint,
      );
    }

    // Draw crankshaft center
    canvas.drawCircle(center, radius * 0.12, fillPaint);
    canvas.drawCircle(center, radius * 0.12, paint);

    canvas.restore();

    // Draw static parts (valves, spark plugs)
    _drawValves(canvas, center, radius, color);
    _drawSparkPlugs(canvas, center, radius, color);
  }

  void _drawValves(Canvas canvas, Offset center, double radius, Color color) {
    final valvePaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final valveStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw 4 valves on top
    for (int i = 0; i < 4; i++) {
      final x = center.dx - radius * 0.5 + (i * radius * 0.33);
      final y = center.dy - radius * 0.5;
      
      final valveRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: radius * 0.15,
          height: radius * 0.2,
        ),
        const Radius.circular(2),
      );
      
      canvas.drawRRect(valveRect, valvePaint);
      canvas.drawRRect(valveRect, valveStroke);
    }
  }

  void _drawSparkPlugs(Canvas canvas, Offset center, double radius, Color color) {
    final plugPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final plugStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw spark plugs on sides
    for (int i = 0; i < 2; i++) {
      final x = center.dx + (i == 0 ? -radius * 0.6 : radius * 0.6);
      final y = center.dy;
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: radius * 0.1,
          height: radius * 0.3,
        ),
        plugPaint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: radius * 0.1,
          height: radius * 0.3,
        ),
        plugStroke,
      );
    }
  }

  @override
  bool shouldRepaint(_EnginePainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.color != color;
  }
}

