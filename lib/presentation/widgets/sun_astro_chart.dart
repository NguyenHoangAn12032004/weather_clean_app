import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather.dart';
import 'glass_container.dart';

class SunAstroChart extends StatelessWidget {
  final WeatherEntity weather;

  const SunAstroChart({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Math logic
    final now = DateTime.now();
    // Convert timestamps to DateTime
    // Note: sunrise/sunset are unix timestamps (seconds).
    // weather.timezone is offset in seconds.
    // We need to be careful with comparison. 
    // Best way: Use comparison based on UTC timestamps + offset if needed, or just standard DateTime comparison if device time is sync.
    // Let's rely on standard DateTime objects.
    
    final sunriseTime = DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000);
    final sunsetTime = DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000);
    
    // Check if it's "today" relative to the sunrise/sunset time provided.
    // If the API returns yesterday's sunset or tomorrow's sunrise, this simple math might be slightly off, but usually Current Weather API returns relevant day's sys.
    
    double progress = 0.0;
    bool isDay = false;

    if (now.isAfter(sunriseTime) && now.isBefore(sunsetTime)) {
      isDay = true;
      final totalDayDuration = sunsetTime.difference(sunriseTime).inMinutes;
      final elapsed = now.difference(sunriseTime).inMinutes;
      progress = elapsed / totalDayDuration;
    } else if (now.isAfter(sunsetTime)) {
      progress = 1.0; // Sun has set
    } else {
      progress = 0.0; // Before sunrise
    }

    // Format times for display (using city timezone)
    String formatTime(int timestamp) {
      final utcDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
      final cityTime = utcDate.add(Duration(seconds: weather.timezone));
      return DateFormat('HH:mm').format(cityTime);
    }
    
    final sunriseStr = formatTime(weather.sunrise);
    final sunsetStr = formatTime(weather.sunset);

    return GlassContainer(
      opacity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text(
                  'MẶT TRỜI',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // The Arc Chart
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomPaint(
                painter: _SunArcPainter(progress: progress, isDay: isDay),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Labels
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        'Mọc: $sunriseStr',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                     Positioned(
                      right: 0,
                      bottom: 0,
                      child: Text(
                        'Lặn: $sunsetStr',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final bool isDay;

  _SunArcPainter({required this.progress, required this.isDay});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height); // Bottom center
    final radius = size.width / 2 - 20; // Padding
    
    final paintLine = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw full arc (Horizon semicircle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start at 180 deg (Left)
      pi, // Sweep 180 deg (to Right)
      false,
      paintLine,
    );
    
    // Draw Sun Position
    // Angle: starts at PI (left), goes clockwise to 2*PI (right)
    // Actually in Flutter coord system:
    // 0 is right, PI is left.
    // Drawing arc from PI with sweep PI goes clockwise to 2*PI (Right).
    
    // Calculate current angle based on progress
    // Progress 0 -> Angle PI
    // Progress 1 -> Angle 2*PI (or 0)
    // Formula: angle = PI + (progress * PI)
    
    final sunAngle = pi + (progress * pi);
    
    final sunX = center.dx + radius * cos(sunAngle);
    final sunY = center.dy + radius * sin(sunAngle);
    
    final sunPaint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill;
      
    final glowPaint = Paint()
        ..color = Colors.orangeAccent.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Only draw sun if it's effectively "day" or handled progress
    // If progress is strictly 0 or 1, we might clip it to horizon
    
    canvas.drawCircle(Offset(sunX, sunY), 12, glowPaint);
    canvas.drawCircle(Offset(sunX, sunY), 6, sunPaint);
    
    // Draw horizon line
    final horizonPaint = Paint()
        ..color = Colors.white10
        ..strokeWidth = 1;
    canvas.drawLine(
        Offset(0, size.height), 
        Offset(size.width, size.height), 
        horizonPaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
