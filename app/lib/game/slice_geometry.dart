import 'package:flame/extensions.dart';

bool segmentHitsCircle(
  Vector2 segA,
  Vector2 segB,
  Vector2 center,
  double radius,
) {
  final Vector2 ab = segB - segA;
  final double ab2 = ab.length2;
  if (ab2 < 1e-8) {
    return (segA - center).length2 <= radius * radius;
  }
  final Vector2 ac = center - segA;
  final double t = (ac.dot(ab) / ab2).clamp(0.0, 1.0);
  final Vector2 closest = segA + ab * t;
  return (closest - center).length2 <= radius * radius;
}
