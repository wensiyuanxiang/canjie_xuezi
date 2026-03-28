import type { TrailPoint } from "../input/InputTracker";

export interface HittableStone {
  x: number;
  y: number;
  radius: number;
}

export class HitSystem {
  wasHit(points: TrailPoint[], stone: HittableStone): boolean {
    if (points.length < 2) {
      return false;
    }

    for (let index = 1; index < points.length; index += 1) {
      const start = points[index - 1];
      const end = points[index];
      const distance = this.distanceToSegment(stone.x, stone.y, start.x, start.y, end.x, end.y);
      if (distance <= stone.radius + 18) {
        return true;
      }
    }

    return false;
  }

  private distanceToSegment(
    px: number,
    py: number,
    x1: number,
    y1: number,
    x2: number,
    y2: number,
  ): number {
    const dx = x2 - x1;
    const dy = y2 - y1;

    if (dx === 0 && dy === 0) {
      return Math.hypot(px - x1, py - y1);
    }

    const t = ((px - x1) * dx + (py - y1) * dy) / (dx * dx + dy * dy);
    const clamped = Math.max(0, Math.min(1, t));
    const closestX = x1 + clamped * dx;
    const closestY = y1 + clamped * dy;

    return Math.hypot(px - closestX, py - closestY);
  }
}
