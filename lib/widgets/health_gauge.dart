import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomHealthGauge extends StatefulWidget {
  final int percentage;
  final double size;

  const CustomHealthGauge({
    super.key,
    required this.percentage,
    this.size = 120,
  });

  @override
  State<CustomHealthGauge> createState() => _CustomHealthGaugeState();
}

class _CustomHealthGaugeState extends State<CustomHealthGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CustomHealthGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.percentage / 100,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getHealthColor(double percentage) {
    if (percentage >= 0.8) {
      return const Color(0xFF00A550); // Green
    } else if (percentage >= 0.5) {
      return const Color(0xFFFFA500); // Orange
    } else {
      return const Color(0xFFE74C3C); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _HealthGaugePainter(
              percentage: _animation.value,
              color: _getHealthColor(_animation.value),
            ),
          ),
        );
      },
    );
  }
}

class _HealthGaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  _HealthGaugePainter({
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.25;

    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Foreground arc (health percentage)
    final foregroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.7),
          color,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle * percentage,
      false,
      foregroundPaint,
    );

    // Indicator needle
    final needleAngle = startAngle + (sweepAngle * percentage);
    final needleEndX = center.dx + (radius - strokeWidth) * math.cos(needleAngle);
    final needleEndY = center.dy + (radius - strokeWidth) * math.sin(needleAngle);

    final needlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw needle circle
    canvas.drawCircle(center, strokeWidth * 0.3, needlePaint);

    // Draw needle line
    final needleLinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(needleEndX, needleEndY),
      needleLinePaint,
    );

    // Draw center circle
    final centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, strokeWidth * 0.15, centerCirclePaint);
  }

  @override
  bool shouldRepaint(_HealthGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}