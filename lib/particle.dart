import 'package:flutter/material.dart';
import 'dart:math';

class ParticleBackground extends StatefulWidget {
  final AnimationController animationController;

  const ParticleBackground({super.key, required this.animationController});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> {
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initParticles();
    widget.animationController.addListener(_updateParticles);
  }

  void _initParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        speed: _random.nextDouble() * 0.005 + 0.001,
        direction: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        particle.x += cos(particle.direction) * particle.speed;
        particle.y += sin(particle.direction) * particle.speed;

        // Wrap around screen
        if (particle.x < 0) particle.x = 1;
        if (particle.x > 1) particle.x = 0;
        if (particle.y < 0) particle.y = 1;
        if (particle.y > 1) particle.y = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(_particles),
      child: Container(),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);

    for (var particle in particles) {
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return true; // Always repaint to show particle movement
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double direction;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.direction,
  });
}
