import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/models/level_config.dart';

class FlyingGlyph extends PositionComponent {
  FlyingGlyph({
    required this.glyph,
    required this.isTarget,
    required Vector2 velocity,
    required this.hitRadius,
    required Vector2 position,
    required double xMin,
    required double xMax,
    required double yMin,
    required double yMax,
  })  : _velocity = velocity.clone(),
        _xMin = xMin,
        _xMax = xMax,
        _yMin = yMin,
        _yMax = yMax,
        super(
          anchor: Anchor.center,
          position: position,
        );

  final String glyph;
  final bool isTarget;
  final double hitRadius;
  final double _xMin;
  final double _xMax;
  final double _yMin;
  final double _yMax;
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
    position += _velocity * dt;

    if (position.x < _xMin) {
      position.x = _xMin;
      _velocity.x = _velocity.x.abs();
    } else if (position.x > _xMax) {
      position.x = _xMax;
      _velocity.x = -_velocity.x.abs();
    }
    if (position.y < _yMin) {
      position.y = _yMin;
      _velocity.y = _velocity.y.abs();
    } else if (position.y > _yMax) {
      position.y = _yMax;
      _velocity.y = -_velocity.y.abs();
    }
  }

  Vector2 get hitCenter => position;
}

List<String> distractorPool(LevelConfig config) {
  const List<String> mountain = <String>['山', '水', '木', '火', '土', '石'];
  return mountain.where((String g) => g != config.targetGlyph).toList();
}
