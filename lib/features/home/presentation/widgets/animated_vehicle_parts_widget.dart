import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Floating vehicle parts animation for background decoration
class AnimatedVehiclePartsWidget extends StatefulWidget {
  final double width;
  final double height;
  
  const AnimatedVehiclePartsWidget({
    super.key,
    this.width = 200,
    this.height = 200,
  });

  @override
  State<AnimatedVehiclePartsWidget> createState() => _AnimatedVehiclePartsWidgetState();
}

class _AnimatedVehiclePartsWidgetState extends State<AnimatedVehiclePartsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
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
          size: Size(widget.width, widget.height),
          painter: VehiclePartsPainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class VehiclePartsPainter extends CustomPainter {
  final double progress;

  VehiclePartsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw various vehicle parts floating around
    final parts = [
      _PartData(offset: Offset(size.width * 0.2, size.height * 0.3), type: 'gear'),
      _PartData(offset: Offset(size.width * 0.8, size.height * 0.4), type: 'bolt'),
      _PartData(offset: Offset(size.width * 0.3, size.height * 0.7), type: 'nut'),
      _PartData(offset: Offset(size.width * 0.7, size.height * 0.2), type: 'washer'),
    ];

    for (var part in parts) {
      final animatedOffset = Offset(
        part.offset.dx + math.sin(progress * 2 * math.pi) * 5,
        part.offset.dy + math.cos(progress * 2 * math.pi) * 5,
      );
      
      _drawPart(canvas, animatedOffset, part.type);
    }
  }

  void _drawPart(Canvas canvas, Offset center, String type) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (type) {
      case 'gear':
        _drawGear(canvas, center, 12, paint);
        break;
      case 'bolt':
        _drawBolt(canvas, center, paint);
        break;
      case 'nut':
        _drawNut(canvas, center, paint);
        break;
      case 'washer':
        _drawWasher(canvas, center, paint);
        break;
    }
  }

  void _drawGear(Canvas canvas, Offset center, int teeth, Paint paint) {
    final radius = 8.0;
    final path = Path();
    
    for (int i = 0; i < teeth; i++) {
      final angle = i * 2 * math.pi / teeth;
      final outerRadius = radius;
      final innerRadius = radius * 0.7;
      
      final x1 = center.dx + outerRadius * math.cos(angle);
      final y1 = center.dy + outerRadius * math.sin(angle);
      
      final angle2 = ((i + 0.5) * 2 * math.pi / teeth);
      final x2 = center.dx + innerRadius * math.cos(angle2);
      final y2 = center.dy + innerRadius * math.sin(angle2);
      
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, radius * 0.4, paint);
  }

  void _drawBolt(Canvas canvas, Offset center, Paint paint) {
    // Draw hex head
    final radius = 6.0;
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
    
    // Draw shaft
    final shaftPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = paint.strokeWidth;
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy + 8),
      shaftPaint,
    );
  }

  void _drawNut(Canvas canvas, Offset center, Paint paint) {
    final radius = 5.0;
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, radius * 0.5, paint);
  }

  void _drawWasher(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 6, paint);
    canvas.drawCircle(center, 3, paint);
  }

  @override
  bool shouldRepaint(VehiclePartsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _PartData {
  final Offset offset;
  final String type;

  _PartData({required this.offset, required this.type});
}

