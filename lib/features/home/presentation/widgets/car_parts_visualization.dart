import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

/// Custom painted widget for car parts visualization
/// Lightweight and performant alternative to images
class CarPartsVisualization extends StatelessWidget {
  final double size;
  final Color? color;

  const CarPartsVisualization({
    super.key,
    this.size = 200,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? AppColors.primary;
    
    return CustomPaint(
      size: Size(size, size),
      painter: _CarPartsPainter(color: primaryColor),
    );
  }
}

class _CarPartsPainter extends CustomPainter {
  final Color color;

  _CarPartsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // Draw wheel (rim)
    _drawWheel(canvas, center, radius * 0.4, color);
    
    // Draw brake disc
    _drawBrakeDisc(canvas, center, radius * 0.35, color);
    
    // Draw shock absorber
    _drawShockAbsorber(canvas, Offset(center.dx - radius * 0.6, center.dy), radius * 0.3, color);
    
    // Draw exhaust pipe
    _drawExhaustPipe(canvas, Offset(center.dx + radius * 0.6, center.dy + radius * 0.3), radius * 0.25, color);
    
    // Draw battery
    _drawBattery(canvas, Offset(center.dx, center.dy - radius * 0.6), radius * 0.2, color);
    
    // Draw turbocharger
    _drawTurbocharger(canvas, Offset(center.dx + radius * 0.4, center.dy - radius * 0.4), radius * 0.2, color);
  }

  void _drawWheel(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Outer rim
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, strokePaint);
    
    // Inner rim
    canvas.drawCircle(center, radius * 0.6, strokePaint);
    
    // Spokes
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi) / 5;
      final start = Offset(
        center.dx + math.cos(angle) * radius * 0.6,
        center.dy + math.sin(angle) * radius * 0.6,
      );
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(start, end, strokePaint);
    }
    
    // Center hub
    canvas.drawCircle(center, radius * 0.15, paint);
    canvas.drawCircle(center, radius * 0.15, strokePaint);
  }

  void _drawBrakeDisc(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Disc
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, strokePaint);
    canvas.drawCircle(center, radius * 0.4, strokePaint);
    
    // Ventilation holes
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      final holeCenter = Offset(
        center.dx + math.cos(angle) * radius * 0.7,
        center.dy + math.sin(angle) * radius * 0.7,
      );
      canvas.drawCircle(holeCenter, radius * 0.08, strokePaint);
    }
  }

  void _drawShockAbsorber(Canvas canvas, Offset center, double height, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final width = height * 0.3;
    
    // Main body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: width,
        height: height,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(bodyRect, paint);
    canvas.drawRRect(bodyRect, strokePaint);
    
    // Top mount
    final topRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - height * 0.4),
        width: width * 1.5,
        height: height * 0.2,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(topRect, paint);
    canvas.drawRRect(topRect, strokePaint);
    
    // Bottom mount
    final bottomRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + height * 0.4),
        width: width * 1.3,
        height: height * 0.15,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(bottomRect, paint);
    canvas.drawRRect(bottomRect, strokePaint);
  }

  void _drawExhaustPipe(Canvas canvas, Offset center, double length, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final width = length * 0.4;
    
    // Main pipe
    final pipeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: length,
        height: width,
      ),
      Radius.circular(width / 2),
    );
    canvas.drawRRect(pipeRect, paint);
    canvas.drawRRect(pipeRect, strokePaint);
    
    // End tip
    final tipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + length * 0.4, center.dy),
        width: length * 0.3,
        height: width * 1.2,
      ),
      Radius.circular(width / 2),
    );
    canvas.drawRRect(tipRect, paint);
    canvas.drawRRect(tipRect, strokePaint);
  }

  void _drawBattery(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Battery body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size * 0.6,
        height: size,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(bodyRect, paint);
    canvas.drawRRect(bodyRect, strokePaint);
    
    // Terminals
    final terminalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - size * 0.4),
        width: size * 0.2,
        height: size * 0.15,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(terminalRect, paint);
    canvas.drawRRect(terminalRect, strokePaint);
    
    // Plus and minus signs
    final textPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Plus sign
    canvas.drawLine(
      Offset(center.dx + size * 0.15, center.dy),
      Offset(center.dx - size * 0.15, center.dy),
      textPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + size * 0.15),
      Offset(center.dx, center.dy - size * 0.15),
      textPaint,
    );
  }

  void _drawTurbocharger(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Main housing (circular)
    canvas.drawCircle(center, size, paint);
    canvas.drawCircle(center, size, strokePaint);
    
    // Inner circle
    canvas.drawCircle(center, size * 0.6, strokePaint);
    
    // Turbine blades
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      final start = Offset(
        center.dx + math.cos(angle) * size * 0.6,
        center.dy + math.sin(angle) * size * 0.6,
      );
      final end = Offset(
        center.dx + math.cos(angle) * size * 0.9,
        center.dy + math.sin(angle) * size * 0.9,
      );
      canvas.drawLine(start, end, strokePaint);
    }
    
    // Center hub
    canvas.drawCircle(center, size * 0.2, paint);
    canvas.drawCircle(center, size * 0.2, strokePaint);
  }

  @override
  bool shouldRepaint(_CarPartsPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

