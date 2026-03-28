import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FloatingComboText extends PositionComponent {
  FloatingComboText({
    required Vector2 position,
    required this.combo,
  }) : super(
          position: position,
          anchor: Anchor.center,
          priority: 600,
        );

  final int combo;
  double _t = 0;
  static const double _life = 0.65;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    position.y -= 42 * dt;
    if (_t >= _life) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final double k = _t / _life;
    final String msg = combo >= 2 ? '连击 x$combo' : '好切！';
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: msg,
        style: TextStyle(
          fontSize: 22 + (1 - k) * 8,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE8892E).withValues(alpha: 1 - k * 0.85),
          shadows: <Shadow>[
            Shadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.6 * (1 - k)),
              blurRadius: 12,
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
