import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/models/level_config.dart';

enum GlyphType { target, distractor, bomb, timeBonus }

class FlyingGlyph extends PositionComponent {
  FlyingGlyph({
    required this.glyph,
    required this.isTarget,
    required Vector2 velocity,
    required this.gravity,
    required this.hitRadius,
    required Vector2 position,
    this.glyphType = GlyphType.distractor,
  })  : _velocity = velocity.clone(),
        super(
          anchor: Anchor.center,
          position: position,
        );

  final String glyph;
  final bool isTarget;
  final double hitRadius;
  final double gravity;
  final GlyphType glyphType;
  final Vector2 _velocity;

  bool sliced = false;
  bool countedMiss = false;
  double age = 0;

  late final TextComponent _text;
  double _pulseT = 0;

  Color get _glyphColor => switch (glyphType) {
        GlyphType.target => const Color(0xFFE8892E),
        GlyphType.distractor => const Color(0xFF5C5C5C),
        GlyphType.bomb => const Color(0xFFC62828),
        GlyphType.timeBonus => const Color(0xFFFF8F00),
      };

  double get _fontSize => switch (glyphType) {
        GlyphType.target => 58,
        GlyphType.distractor => 50,
        GlyphType.bomb => 48,
        GlyphType.timeBonus => 48,
      };

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _text = TextComponent(
      text: glyph,
      anchor: Anchor.center,
      position: Vector2.zero(),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w900,
          color: _glyphColor,
          height: 1,
          shadows: <Shadow>[
            if (glyphType == GlyphType.target)
              Shadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.45),
                blurRadius: 14,
              ),
            if (glyphType == GlyphType.bomb)
              Shadow(
                color: const Color(0xFFFF0000).withValues(alpha: 0.5),
                blurRadius: 18,
              ),
            if (glyphType == GlyphType.timeBonus)
              Shadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                blurRadius: 20,
              ),
          ],
        ),
      ),
    );
    await add(_text);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (sliced) {
      return;
    }
    age += dt;
    _velocity.y += gravity * dt;
    position += _velocity * dt;

    if (glyphType == GlyphType.bomb || glyphType == GlyphType.timeBonus) {
      _pulseT += dt;
      final double pulse = 1.0 + 0.08 * sin(_pulseT * 6);
      scale = Vector2.all(pulse);
    }
  }

  Vector2 get hitCenter => position;
}

List<String> distractorPool(LevelConfig config) {
  const List<String> pool = <String>[
    '山', '水', '木', '火', '土', '石',
    '日', '月', '田', '人', '口', '手', '心', '目', '足', '刀',
    '上', '下', '大', '小', '天', '云', '风', '雨', '草', '花',
    '门', '马', '鸟', '鱼', '虫', '竹', '米', '车', '王', '玉',
  ];
  return pool.where((String g) => g != config.targetGlyph).toList();
}
