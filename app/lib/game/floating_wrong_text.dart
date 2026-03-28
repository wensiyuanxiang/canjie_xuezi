import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FloatingWrongText extends PositionComponent {
  FloatingWrongText({
    required Vector2 position,
    required this.targetGlyph,
  }) : super(
          position: position,
          anchor: Anchor.center,
          priority: 600,
        );

  final String targetGlyph;
  double _t = 0;
  static const double _life = 0.85;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    position.y -= 32 * dt;
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
        text: '切错啦！找「$targetGlyph」',
        style: TextStyle(
          fontSize: 20 + (1 - k) * 4,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE53935).withValues(alpha: alpha),
          shadows: <Shadow>[
            Shadow(
              color: const Color(0xFF000000).withValues(alpha: 0.35 * alpha),
              blurRadius: 8,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(-tp.width / 2, -tp.height / 2),
    );
  }
}
