import 'dart:collection';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../core/audio/sfx_service.dart';
import '../data/models/level_config.dart';
import '../data/models/level_result.dart';
import 'floating_combo_text.dart';
import 'floating_item_text.dart';
import 'floating_wrong_text.dart';
import 'flying_glyph.dart';
import 'slash_trail_component.dart';
import 'slice_burst_effect.dart';
import 'slice_geometry.dart';
import 'slice_hud_snapshot.dart';

class ZaoziSliceGame extends FlameGame with PanDetector {
  ZaoziSliceGame({
    required this.levelConfig,
    required this.onSessionEnd,
    SfxService? sfx,
  })  : _sfx = sfx ?? SfxService(),
        _quota = levelConfig.isBoss ? 8 : 5,
        _timeLeft = levelConfig.isBoss ? 52.0 : 42.0,
        _totalTime = levelConfig.isBoss ? 52.0 : 42.0,
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
  final SfxService _sfx;

  final ValueNotifier<SliceHudSnapshot> hudListenable;

  late final SlashTrailComponent _slash;
  final Random _random = Random();

  double _spawnCooldown = 0.55;
  double _timeLeft;
  final double _totalTime;
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
  final ListQueue<double> _recentSpawnXs = ListQueue<double>();

  double _elapsed = 0;
  double _itemCooldown = 8.0;

  Rect get _visiblePlayRect {
    final Rect rect = camera.parent != null
        ? camera.visibleWorldRect
        : Rect.fromLTWH(0, 0, size.x, size.y);
    final double left = rect.left + 44;
    final double right = rect.right - 44;
    return Rect.fromLTRB(min(left, right - 1), rect.top, max(right, left + 1), rect.bottom);
  }

  double get _screenCenterX => _visiblePlayRect.center.dx;

  double get _recentSpawnAverageX {
    if (_recentSpawnXs.isEmpty) {
      return _screenCenterX;
    }
    return _recentSpawnXs.reduce((double a, double b) => a + b) /
        _recentSpawnXs.length;
  }

  double get _difficulty {
    final double progress = _elapsed / _totalTime;
    return progress.clamp(0.0, 1.0);
  }

  double get _currentGravity => 680 + 220 * _difficulty;

  double get _spawnInterval {
    final double base = levelConfig.isBoss ? 0.45 : 0.55;
    final double minVal = levelConfig.isBoss ? 0.25 : 0.30;
    return base - (base - minVal) * _difficulty;
  }

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _slash = SlashTrailComponent();
    _slash.priority = 1000;
    await world.add(_slash);
    _syncCameraToWidgetSpace();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _syncCameraToWidgetSpace();
    });
    _syncHud(force: true);
  }

  /// Flame's default [Viewfinder] puts world (0,0) at the viewport center.
  /// Gameplay assumes world (0,0) is the top-left of the playfield, so we
  /// center the camera on (size/2, size/2). If this is skipped, spawns in
  /// [0..size.x] cluster on one side and look glued to the screen edge.
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

    _elapsed += dt;
    _timeLeft -= dt;
    _spawnCooldown -= dt;
    _itemCooldown -= dt;

    if (_spawnCooldown <= 0) {
      _trySpawn();
      _spawnCooldown =
          _spawnInterval + _random.nextDouble() * _spawnInterval * 0.8;
    }

    if (_itemCooldown <= 0) {
      _trySpawnItem();
      _itemCooldown = 6.0 + _random.nextDouble() * 5.0;
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
    final int glyphCount =
        flying.where((FlyingGlyph g) => !g.sliced && g.glyphType != GlyphType.bomb && g.glyphType != GlyphType.timeBonus).length;
    final int maxOnScreen = 4 + (_difficulty * 3).round();
    if (glyphCount >= maxOnScreen) {
      return;
    }

    final int targetsInAir =
        flying.where((FlyingGlyph g) => g.isTarget && !g.sliced).length;
    final int remaining = _quota - _correct;

    // 场上没有目标字时必出目标；已有目标时以干扰字为主，提高辨别趣味。
    final bool spawnTarget = remaining > 0 &&
        (targetsInAir == 0 ||
            (targetsInAir == 1 && _random.nextDouble() < 0.22) ||
            (targetsInAir >= 2 && _random.nextDouble() < 0.08));

    final String glyph;
    if (spawnTarget) {
      glyph = levelConfig.targetGlyph;
    } else {
      final List<String> pool = distractorPool(levelConfig);
      glyph = pool[_random.nextInt(pool.length)];
    }

    _spawnGlyph(
      glyph: glyph,
      isTarget: glyph == levelConfig.targetGlyph,
      type: glyph == levelConfig.targetGlyph
          ? GlyphType.target
          : GlyphType.distractor,
    );
  }

  void _rememberSpawnX(double x) {
    _recentSpawnXs.addLast(x);
    while (_recentSpawnXs.length > 8) {
      _recentSpawnXs.removeFirst();
    }
  }

  /// Strong center-bias with adaptive correction: if recent glyphs drift to one
  /// side, nudge the next center in the opposite direction.
  double _sampleSpawnX({double spread = 0.35}) {
    final Rect playRect = _visiblePlayRect;
    final double screenCenter = playRect.center.dx;
    final double drift = _recentSpawnAverageX - screenCenter;
    final double correctedCenter =
        (screenCenter - drift * 0.55).clamp(playRect.left + 20, playRect.right - 20);
    final double halfBand = (playRect.width / 2) * spread;
    // Sum of three uniforms gives a steeper peak than a simple triangle.
    final double t = (_random.nextDouble() +
            _random.nextDouble() +
            _random.nextDouble()) /
        3;
    final double x =
        (correctedCenter + (t - 0.5) * 2 * halfBand).clamp(playRect.left, playRect.right);
    _rememberSpawnX(x);
    return x;
  }

  void _trySpawnItem() {
    if (_elapsed < 5) {
      return;
    }
    final double roll = _random.nextDouble();
    final GlyphType type;
    final String glyph;
    if (roll < 0.45) {
      type = GlyphType.bomb;
      glyph = '墨';
    } else {
      type = GlyphType.timeBonus;
      glyph = '光';
    }
    _spawnGlyph(glyph: glyph, isTarget: false, type: type);
  }

  void _spawnGlyph({
    required String glyph,
    required bool isTarget,
    required GlyphType type,
  }) {
    final double gravity = _currentGravity;
    final bool isMissionTarget =
        type == GlyphType.target && isTarget;
    final double spread = switch (type) {
      GlyphType.target => 0.28,
      GlyphType.distractor => 0.34,
      GlyphType.bomb || GlyphType.timeBonus => 0.24,
    };
    final double x0 = _sampleSpawnX(spread: spread);
    final double y0 = size.y * (0.90 + _random.nextDouble() * 0.08);
    final double riseMin = y0 - size.y * 0.12;
    final double riseMax = y0 + 40;
    final double vMin = sqrt(2 * gravity * riseMin);
    final double vMax = sqrt(2 * gravity * riseMax);
    final double upwardSpeed = vMin + _random.nextDouble() * (vMax - vMin);
    // Add a weak spring toward screen center so glyphs don't live on one side.
    final double centerPull = (_screenCenterX - x0) * 0.18;
    final double vx = centerPull +
        (-1.0 + 2 * _random.nextDouble()) * (isMissionTarget ? 14 : 24);

    world.add(
      FlyingGlyph(
        glyph: glyph,
        isTarget: isTarget,
        gravity: gravity,
        velocity: Vector2(vx, -upwardSpeed),
        hitRadius: 42,
        position: Vector2(x0, y0),
        glyphType: type,
      )..priority = 10,
    );
  }

  void _glyphTimeouts() {
    for (final FlyingGlyph g in world.children.query<FlyingGlyph>()) {
      if (g.sliced) {
        continue;
      }
      if (g.position.y > size.y + 32) {
        if (g.isTarget && !g.countedMiss) {
          g.countedMiss = true;
          _missed++;
          _combo = 0;
        }
        g.removeFromParent();
        continue;
      }
      if (g.position.y < -120) {
        g.removeFromParent();
        continue;
      }
      if (g.position.x < -72 || g.position.x > size.x + 72) {
        if (g.isTarget && !g.countedMiss) {
          g.countedMiss = true;
          _missed++;
          _combo = 0;
        }
        g.removeFromParent();
        continue;
      }
      if (g.isTarget && !g.countedMiss && g.age > 24) {
        g.countedMiss = true;
        _missed++;
        _combo = 0;
        g.removeFromParent();
      } else if (!g.isTarget && g.age > 28) {
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

    switch (g.glyphType) {
      case GlyphType.target:
        _correct++;
        _combo++;
        if (_combo > _maxCombo) {
          _maxCombo = _combo;
        }
        world.add(SliceBurstEffect(center: at, isCorrect: true));
        _sfx.playCut();
        if (_combo >= 2) {
          _sfx.playComboUp();
          world.add(FloatingComboText(position: at, combo: _combo));
        }
        _shakeT = 0.26;

      case GlyphType.distractor:
        _wrong++;
        _combo = 0;
        world.add(SliceBurstEffect(center: at, isCorrect: false));
        _sfx.playSlashWrong();
        world.add(FloatingWrongText(
          position: at,
          targetGlyph: levelConfig.targetGlyph,
        ));
        _shakeT = 0.14;

      case GlyphType.bomb:
        _timeLeft = (_timeLeft - 5).clamp(0.0, double.infinity);
        _combo = 0;
        _wrong++;
        world.add(SliceBurstEffect(center: at, isCorrect: false));
        _sfx.playSlashWrong();
        world.add(FloatingItemText(
          position: at,
          message: '墨怪！-5秒',
          color: const Color(0xFFC62828),
        ));
        _shakeT = 0.5;

      case GlyphType.timeBonus:
        _timeLeft += 5;
        world.add(SliceBurstEffect(center: at, isCorrect: true));
        _sfx.playCut();
        world.add(FloatingItemText(
          position: at,
          message: '光之精灵 +5秒',
          color: const Color(0xFFFF8F00),
        ));
        _shakeT = 0.2;
    }

    g.removeFromParent();
  }

  void _finishSession() {
    if (_ended) {
      return;
    }
    _ended = true;
    final bool cleared = _correct >= _quota;
    if (cleared) {
      _sfx.playLevelClear();
    }
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
