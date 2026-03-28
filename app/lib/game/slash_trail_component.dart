import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class _TimedPoint {
  _TimedPoint(this.offset);

  final Offset offset;
  double age = 0;
}

/// 笔锋轨迹：松手后按点龄快速淡出，不在屏幕上常驻。
class SlashTrailComponent extends Component {
  SlashTrailComponent({
    this.pointMaxAge = 0.2,
    this.maxPoints = 72,
  });

  final double pointMaxAge;
  final int maxPoints;
  final List<_TimedPoint> _points = <_TimedPoint>[];

  void clear() => _points.clear();

  void addPoint(Offset p) {
    _points.add(_TimedPoint(p));
    while (_points.length > maxPoints) {
      _points.removeAt(0);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final _TimedPoint p in _points) {
      p.age += dt;
    }
    _points.removeWhere((_TimedPoint p) => p.age >= pointMaxAge);
  }

  double _alphaFor(_TimedPoint p) =>
      (1 - p.age / pointMaxAge).clamp(0.0, 1.0);

  @override
  void render(Canvas canvas) {
    if (_points.length < 2) {
      return;
    }
    for (int i = 0; i < _points.length - 1; i++) {
      final _TimedPoint a = _points[i];
      final _TimedPoint b = _points[i + 1];
      final double alpha =
          ((_alphaFor(a) + _alphaFor(b)) / 2).clamp(0.0, 1.0);
      if (alpha < 0.02) {
        continue;
      }
      final Path seg = Path()
        ..moveTo(a.offset.dx, a.offset.dy)
        ..lineTo(b.offset.dx, b.offset.dy);

      canvas.drawPath(
        seg,
        Paint()
          ..color = const Color(0xFFFF9F43).withValues(alpha: 0.22 * alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawPath(
        seg,
        Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: 0.4 * alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawPath(
        seg,
        Paint()
          ..color = const Color(0xFFFFF8E7).withValues(alpha: 0.9 * alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
  }
}
