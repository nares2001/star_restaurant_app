import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:star_mesas_app/app/config/preferences/datosVarios.dart';

class AnimatedBubblesBackground extends StatefulWidget {
  final bool showBooble;
  final Widget child;

  const AnimatedBubblesBackground({
    super.key,
    required this.child,
    this.showBooble = false,
  });

  @override
  State<AnimatedBubblesBackground> createState() =>
      _AnimatedBubblesBackgroundState();
}

class _AnimatedBubblesBackgroundState extends State<AnimatedBubblesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 30; i++) {
        _bubbles.add(
          Bubble(
            x: _random.nextDouble() * size.width,
            y: _random.nextDouble() * size.height,
            radius: _random.nextDouble() * 40 + 10,
            speedY: _random.nextDouble() * 1.5 + 0.5,
            speedX: (_random.nextDouble() - 0.5) * 0.5,
            color: const Color.fromARGB(
              255,
              16,
              61,
              121,
            ).withOpacity(_random.nextDouble() * 0.08 + 0.02),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Striking Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FAFC), Color.fromARGB(255, 217, 222, 230)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // 2. Animated Bubbles
        if (widget.showBooble) ...[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final size = MediaQuery.of(context).size;
              _updateBubbles(size);
              return CustomPaint(painter: BubblePainter(_bubbles), size: size);
            },
          ),
        ],

        // 3. Floating Logo (bottom right)
        Positioned(
          bottom: 70,
          right: 0,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Movimiento suave de flotación usando una onda senoidal
              final dy = sin(_controller.value * 2 * pi) * 15;
              return Transform.translate(offset: Offset(0, dy), child: child);
            },
            child: Opacity(
              opacity: 0.20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DatosVarios().logoPrin.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: DatosVarios().logoPrin,
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const SizedBox.shrink(),
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              'assets/images/logo.png',
                              width: MediaQuery.of(context).size.width * 0.5,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                ],
              ),
            ),
          ),
        ),

        // 4. Foreground Content
        widget.child,
      ],
    );
  }

  void _updateBubbles(Size size) {
    for (var bubble in _bubbles) {
      bubble.y -= bubble.speedY;
      bubble.x += bubble.speedX;

      if (bubble.y + bubble.radius < 0) {
        bubble.y = size.height + bubble.radius;
        bubble.x = _random.nextDouble() * size.width;
      }

      if (bubble.x > size.width + bubble.radius) {
        bubble.x = -bubble.radius;
      } else if (bubble.x < -bubble.radius) {
        bubble.x = size.width + bubble.radius;
      }
    }
  }
}

class Bubble {
  double x;
  double y;
  double radius;
  double speedY;
  double speedX;
  Color color;

  Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedY,
    required this.speedX,
    required this.color,
  });
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;

  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      final paint = Paint()
        ..color = bubble.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) => true;
}
