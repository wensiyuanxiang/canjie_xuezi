import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FloatingItemText extends PositionComponent {
  FloatingItemText({
    required Vector2 position,
    required this.message,
    required this.color,
  }) : super(
          position: position,
          anchor: Anchor.center,
          priority: 600,
        );

  final String message;
  final Color color;
  double _t = 0;
  static const double _life = 0.9;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    position.y -= 38 * dt;
    if (_t >= _life) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final double k = _t / _life;
    final double alpha = (1 - k * 0.8).clamp(0.0, 1.0);
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: message,
        style: TextStyle(
          fontSize: 24 + (1 - k) * 6,
          fontWeight: FontWeight.w900,
          color: color.withValues(alpha: alpha),
          shadows: <Shadow>[
            Shadow(
              color: Colors.black.withValues(alpha: 0.3 * alpha),
              blurRadius: 10,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  }
}
