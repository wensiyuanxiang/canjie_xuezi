import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';

import '../data/models/level_config.dart';
import '../data/models/level_result.dart';
import 'floating_combo_text.dart';
import 'flying_glyph.dart';
import 'slash_trail_component.dart';
import 'slice_burst_effect.dart';
import 'slice_geometry.dart';
import 'slice_hud_snapshot.dart';

class ZaoziSliceGame extends FlameGame with PanDetector {
  ZaoziSliceGame({
    required this.levelConfig,
    required this.onSessionEnd,
  })  : _quota = levelConfig.isBoss ? 8 : 5,
        _timeLeft = levelConfig.isBoss ? 52.0 : 42.0,
        hudListenable = ValueNotifier<SliceHudSnapshot>(
          SliceHudSnapshot(
            timeLeft: levelConfig.isBoss ? 52.0 : 42.0,
            correct: 0,
            quota: levelConfig.isBoss ? 8 : 5,
            combo: 0,
            wrong: 0,
            missed: 0,
            ended: false,
          ),
        );

  final LevelConfig levelConfig;
  final void Function(LevelResult result) onSessionEnd;

  final ValueNotifier<SliceHudSnapshot> hudListenable;

  late final SlashTrailComponent _slash;
  final Random _random = Random();

  double _spawnCooldown = 0.55;
  double _timeLeft;
  final int _quota;

  int _correct = 0;
  int _missed = 0;
  int _wrong = 0;
  int _combo = 0;
  int _maxCombo = 0;

  Vector2? _prevSlash;
  bool _ended = false;

  final Vector2 _viewBase = Vector2.zero();
  double _shakeT = 0;

  double get _playYMin => size.y * 0.25;
  double get _playYMax => size.y * 0.75;
  double get _playXMin => 56;
  double get _playXMax => size.x - 56;

  @override
  Color backgroundColor() => const Color(0xFFF5F0E8);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _slash = SlashTrailComponent();
    _slash.priority = 1000;
    await world.add(_slash);
    _syncCameraToWidgetSpace();
    _syncHud(force: true);
  }

  void _syncCameraToWidgetSpace() {
    if (size.x < 64 || size.y < 64) {
      return;
    }
    _viewBase.setValues(size.x / 2, size.y / 2);
    if (_shakeT <= 0) {
      camera.viewfinder.position.setFrom(_viewBase);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _syncCameraToWidgetSpace();
  }

  void _applyCameraShake(double dt) {
    _syncCameraToWidgetSpace();
    if (_shakeT > 0) {
      _shakeT -= dt;
      final double mag = (_shakeT * 6).clamp(0.0, 1.0);
      camera.viewfinder.position.setValues(
        _viewBase.x + (_random.nextDouble() - 0.5) * 18 * mag,
        _viewBase.y + (_random.nextDouble() - 0.5) * 15 * mag,
      );
    } else {
      camera.viewfinder.position.setFrom(_viewBase);
    }
  }

  void _syncHud({bool force = false}) {
    final SliceHudSnapshot next = SliceHudSnapshot(
      timeLeft: _timeLeft < 0 ? 0 : _timeLeft,
      correct: _correct,
      quota: _quota,
      combo: _combo,
      wrong: _wrong,
      missed: _missed,
      ended: _ended,
    );
    if (force || next.differsFrom(hudListenable.value)) {
      hudListenable.value = next;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _applyCameraShake(dt);

    if (_ended || size.x < 64 || size.y < 64) {
      _syncHud();
      return;
    }

    _timeLeft -= dt;
    _spawnCooldown -= dt;
    if (_spawnCooldown <= 0) {
      _trySpawn();
      _spawnCooldown = 0.55 + _random.nextDouble() * 0.55;
    }

    _glyphTimeouts();

    if (_correct >= _quota) {
      _finishSession();
    } else if (_timeLeft <= 0) {
      _finishSession();
    }
    _syncHud();
  }

  void _trySpawn() {
    final List<FlyingGlyph> flying =
        world.children.query<FlyingGlyph>().toList();
    if (flying.length >= 6) {
      return;
    }

    final int targetsInAir =
        flying.where((FlyingGlyph g) => g.isTarget && !g.sliced).length;
    final int remaining = _quota - _correct;
    final bool needTarget =
        remaining > 0 && (targetsInAir < 2 || _random.nextDouble() < 0.38);
    final bool spawnTarget =
        needTarget && (targetsInAir == 0 || _random.nextDouble() < 0.52);

    final String glyph;
    if (spawnTarget) {
      glyph = levelConfig.targetGlyph;
    } else {
      final List<String> pool = distractorPool(levelConfig);
      glyph = pool[_random.nextInt(pool.length)];
    }

    final double ySpan = _playYMax - _playYMin;
    final double yInset = min(90.0, ySpan * 0.14);
    final double yLo = _playYMin + yInset;
    final double yHi = _playYMax - yInset;
    final double y0 = yLo + _random.nextDouble() * (yHi - yLo);
    final double x0 =
        _playXMin + _random.nextDouble() * (_playXMax - _playXMin);
    final double vx = -190 + _random.nextDouble() * 380;
    final double vy = -130 + _random.nextDouble() * 260;

    world.add(
      FlyingGlyph(
        glyph: glyph,
        isTarget: glyph == levelConfig.targetGlyph,
        velocity: Vector2(vx, vy),
        hitRadius: 42,
        position: Vector2(x0, y0),
        xMin: _playXMin,
        xMax: _playXMax,
        yMin: _playYMin,
        yMax: _playYMax,
      )..priority = 10,
    );
  }

  void _glyphTimeouts() {
    for (final FlyingGlyph g in world.children.query<FlyingGlyph>()) {
      if (g.sliced) {
        continue;
      }
      if (g.isTarget && !g.countedMiss && g.age > 14) {
        g.countedMiss = true;
        _missed++;
        _combo = 0;
        g.removeFromParent();
      } else if (!g.isTarget && g.age > 20) {
        g.removeFromParent();
      }
    }
  }

  Vector2 _canvasPointToWorld(Vector2 canvas) {
    return camera.globalToLocal(Vector2(canvas.x, canvas.y));
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (_ended) {
      return;
    }
    _slash.clear();
    _prevSlash = _canvasPointToWorld(info.eventPosition.widget);
    _slash.addPoint(Offset(_prevSlash!.x, _prevSlash!.y));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_ended) {
      return;
    }
    final Vector2 cur = _canvasPointToWorld(info.eventPosition.widget);
    _slash.addPoint(Offset(cur.x, cur.y));
    if (_prevSlash != null) {
      _checkSlashSegment(_prevSlash!, cur);
    }
    _prevSlash = Vector2.copy(cur);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _prevSlash = null;
  }

  @override
  void onPanCancel() {
    _prevSlash = null;
  }

  void _checkSlashSegment(Vector2 a, Vector2 b) {
    for (final FlyingGlyph g in world.children.query<FlyingGlyph>()) {
      if (g.sliced) {
        continue;
      }
      if (segmentHitsCircle(a, b, g.hitCenter, g.hitRadius + 16)) {
        _applySlice(g);
      }
    }
  }

  void _applySlice(FlyingGlyph g) {
    if (g.sliced) {
      return;
    }
    g.sliced = true;
    final Vector2 at = Vector2.copy(g.hitCenter);
    final bool ok = g.isTarget;
    if (ok) {
      _correct++;
      _combo++;
      if (_combo > _maxCombo) {
        _maxCombo = _combo;
      }
    } else {
      _wrong++;
      _combo = 0;
    }

    world.add(SliceBurstEffect(center: at, isCorrect: ok));
    if (ok && _combo >= 2) {
      world.add(FloatingComboText(position: at, combo: _combo));
    }
    _shakeT = ok ? 0.26 : 0.14;

    g.removeFromParent();
  }

  void _finishSession() {
    if (_ended) {
      return;
    }
    _ended = true;
    final bool cleared = _correct >= _quota;
    _syncHud(force: true);
    onSessionEnd(
      LevelResult(
        levelId: levelConfig.id,
        correctCount: _correct,
        missedCount: _missed,
        wrongSlashCount: _wrong,
        maxCombo: _maxCombo,
        levelCleared: cleared,
      ),
    );
  }

  void exitToResultManually() {
    if (_ended) {
      return;
    }
    _ended = true;
    _syncHud(force: true);
    onSessionEnd(
      LevelResult(
        levelId: levelConfig.id,
        correctCount: _correct,
        missedCount: _missed,
        wrongSlashCount: _wrong,
        maxCombo: _maxCombo,
        levelCleared: _correct >= _quota,
      ),
    );
  }

}
