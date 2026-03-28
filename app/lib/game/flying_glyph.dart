import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/models/level_config.dart';

/// 水果忍者式：自屏幕 0.25–0.75 高度带下缘向上抛出，仅受重力，不贴边弹跳。
class FlyingGlyph extends PositionComponent {
  FlyingGlyph({
    required this.glyph,
    required this.isTarget,
    required Vector2 velocity,
    required this.gravity,
    required this.hitRadius,
    required Vector2 position,
  })  : _velocity = velocity.clone(),
        super(
          anchor: Anchor.center,
          position: position,
        );

  final String glyph;
  final bool isTarget;
  final double hitRadius;
  final double gravity;
  final Vector2 _velocity;

  bool sliced = false;
  bool countedMiss = false;
  double age = 0;

  late final TextComponent _text;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _text = TextComponent(
      text: glyph,
      anchor: Anchor.center,
      position: Vector2.zero(),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: isTarget ? 58 : 50,
          fontWeight: FontWeight.w900,
          color: isTarget
              ? const Color(0xFFE8892E)
              : const Color(0xFF5C5C5C),
          height: 1,
          shadows: <Shadow>[
            if (isTarget)
              Shadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.45),
                blurRadius: 14,
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
  }

  Vector2 get hitCenter => position;
}

List<String> distractorPool(LevelConfig config) {
  const List<String> mountain = <String>['山', '水', '木', '火', '土', '石'];
  return mountain.where((String g) => g != config.targetGlyph).toList();
}
