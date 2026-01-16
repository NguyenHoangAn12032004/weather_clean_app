import 'dart:math';
import 'package:flutter/material.dart';

enum WeatherEffect { none, rain, snow, sunny }

class WeatherEffectsLayer extends StatefulWidget {
  final String iconCode;

  const WeatherEffectsLayer({super.key, required this.iconCode});

  @override
  State<WeatherEffectsLayer> createState() => _WeatherEffectsLayerState();
}

class _WeatherEffectsLayerState extends State<WeatherEffectsLayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();
  WeatherEffect _effect = WeatherEffect.none;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _updateEffect();
  }

  @override
  void didUpdateWidget(covariant WeatherEffectsLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconCode != widget.iconCode) {
      _updateEffect();
    }
  }

  void _updateEffect() {
    _particles.clear();
    final code = widget.iconCode;
    
    // Determine effect
    if (['09d', '09n', '10d', '10n', '11d', '11n'].contains(code)) {
      _effect = WeatherEffect.rain;
      _generateParticles(100); // 100 rain drops
    } else if (['13d', '13n'].contains(code)) {
      _effect = WeatherEffect.snow;
      _generateParticles(50); // 50 snow flakes
    } else if (code == '01d') {
      _effect = WeatherEffect.sunny; 
       // For sunny, maybe just subtle light rays (simulated by particles) or nothing for now
       // keeping it simple to avoid clutter
       _effect = WeatherEffect.none; 
    } else {
      _effect = WeatherEffect.none;
    }
  }

  void _generateParticles(int count) {
    for (int i = 0; i < count; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: _random.nextDouble() * 0.02 + 0.01,
        length: _random.nextDouble() * 20 + 10,
        opacity: _random.nextDouble() * 0.5 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_effect == WeatherEffect.none) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            effect: _effect,
            random: _random,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x; // 0.0 to 1.0
  double y; // 0.0 to 1.0
  double speed;
  double length;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final WeatherEffect effect;
  final Random random;

  _ParticlePainter({
    required this.particles,
    required this.effect,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Update position
      particle.y += particle.speed;
      if (particle.y > 1.0) {
        particle.y = -0.1;
        particle.x = random.nextDouble();
      }

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      paint.color = Colors.white.withValues(alpha: particle.opacity);

      if (effect == WeatherEffect.rain) {
        paint.strokeWidth = 1.5;
        canvas.drawLine(Offset(x, y), Offset(x - 2, y + particle.length), paint); // Slight tilt
      } else if (effect == WeatherEffect.snow) {
         canvas.drawCircle(Offset(x, y), 2.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
