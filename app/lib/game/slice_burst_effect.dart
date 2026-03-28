import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 切中目标：暖金 + 柔绿星芒 + 外扩环。
/// 切错：冷色 X 裂 + 内收碎点。
class SliceBurstEffect extends PositionComponent {
  SliceBurstEffect({
    required Vector2 center,
    required this.isCorrect,
  }) : super(
          position: center,
          anchor: Anchor.center,
          priority: 500,
        );

  final bool isCorrect;
  double _t = 0;
  static const double _lifeCorrect = 0.48;
  static const double _lifeWrong = 0.4;

  double get _life => isCorrect ? _lifeCorrect : _lifeWrong;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= _life) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    if (isCorrect) {
      _renderCorrect(canvas);
    } else {
      _renderWrong(canvas);
    }
  }

  void _renderCorrect(Canvas canvas) {
    final double k = _t / _life;
    final double ease = 1 - (1 - k) * (1 - k);
    const Color gold = Color(0xFFFFD700);
    const Color orange = Color(0xFFFF9F43);
    const Color green = Color(0xFF6BCB77);

    final Paint ray = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;

    const int rays = 16;
    for (int i = 0; i < rays; i++) {
      final double ang = i * 2 * pi / rays + _t * 5;
      final double len = 24 + ease * 125;
      final Color c = Color.lerp(orange, gold, ease)!;
      ray.color = c.withValues(alpha: (1 - k) * 0.92);
      canvas.drawLine(
        Offset.zero,
        Offset(cos(ang) * len, sin(ang) * len),
        ray,
      );
    }

    final Paint ringGold = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = gold.withValues(alpha: (1 - k) * 0.8);
    canvas.drawCircle(Offset.zero, 14 + ease * 92, ringGold);

    final Paint ringGreen = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = green.withValues(alpha: (1 - k) * 0.55);
    canvas.drawCircle(Offset.zero, 28 + ease * 108, ringGreen);

    final Paint glow = Paint()
      ..color = orange.withValues(alpha: 0.2 * (1 - k));
    canvas.drawCircle(Offset.zero, 18 + ease * 105, glow);

    for (int s = 0; s < 12; s++) {
      final double ang = s * 2 * pi / 12 + _t * 2;
      final double dist = 20 + ease * 95;
      final double sz = (1 - k) * 5 + 2;
      canvas.drawCircle(
        Offset(cos(ang) * dist, sin(ang) * dist),
        sz,
        Paint()..color = gold.withValues(alpha: (1 - k) * 0.85),
      );
      canvas.drawCircle(
        Offset(cos(ang + 0.2) * dist * 0.88, sin(ang + 0.2) * dist * 0.88),
        sz * 0.55,
        Paint()..color = green.withValues(alpha: (1 - k) * 0.7),
      );
    }

    final Paint core = Paint()
      ..color = const Color(0xFFFFF8E7).withValues(alpha: (1 - k) * 0.95);
    canvas.drawCircle(Offset.zero, 10 * (1 - k * 0.4), core);
  }

  void _renderWrong(Canvas canvas) {
    final double k = _t / _life;
    final double ease = 1 - (1 - k) * (1 - k);
    const Color cool = Color(0xFF6C8EBF);
    const Color frost = Color(0xFFB8C5D6);
    const Color ink = Color(0xFF5C6B7A);

    final double len = 22 + ease * 68;
    final double w = 4 * (1 - k * 0.5);
    final Paint xPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(cool, frost, ease)!
          .withValues(alpha: (1 - k) * 0.9);

    canvas.drawLine(Offset(-len, -len), Offset(len, len), xPaint);
    canvas.drawLine(Offset(-len, len), Offset(len, -len), xPaint);

    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = cool.withValues(alpha: (1 - k) * 0.45);
    canvas.drawCircle(Offset.zero, 16 + ease * 52, ring);

    final Paint mist = Paint()
      ..color = frost.withValues(alpha: 0.18 * (1 - k));
    canvas.drawCircle(Offset.zero, 30 + ease * 40, mist);

    for (int i = 0; i < 9; i++) {
      final double ang = i * 2 * pi / 9 + 0.5;
      final double start = 8 + ease * 35;
      final double end = 4 + ease * 12;
      final Paint shard = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = ink.withValues(alpha: (1 - k) * 0.55);
      canvas.drawLine(
        Offset(cos(ang) * start, sin(ang) * start),
        Offset(cos(ang) * end, sin(ang) * end),
        shard,
      );
    }

    for (int j = 0; j < 14; j++) {
      final double ang = j * 2 * pi / 14 + _t * 3;
      final double r = 3.2 + (j % 4) * 0.95;
      final double dist = 12 + (1 - ease) * 55;
      canvas.drawCircle(
        Offset(cos(ang) * dist, sin(ang) * dist),
        r * (1 - k),
        Paint()..color = cool.withValues(alpha: (1 - k) * 0.35),
      );
    }
  }
}
