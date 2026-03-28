import type { InputTracker } from "./InputTracker";

export interface NormalizedHandPoint {
  normalizedX: number;
  normalizedY: number;
}

export class HandTrackingAdapter {
  private lastPoint: NormalizedHandPoint | null = null;

  constructor(
    private readonly tracker: InputTracker,
    private readonly width: number,
    private readonly height: number,
    private readonly leftHandMode: boolean,
    private readonly sensitivity: number,
  ) {}

  update(point: NormalizedHandPoint | null): void {
    if (!point) {
      this.lastPoint = null;
      this.tracker.end();
      return;
    }

    const normalizedX = this.leftHandMode ? 1 - point.normalizedX : point.normalizedX;
    const x = normalizedX * this.width;
    const y = point.normalizedY * this.height;

    if (!this.lastPoint) {
      this.lastPoint = point;
      this.tracker.begin({ x, y });
      return;
    }

    const delta = Math.hypot(
      point.normalizedX - this.lastPoint.normalizedX,
      point.normalizedY - this.lastPoint.normalizedY,
    );

    if (delta >= Math.max(0.006, this.sensitivity * 0.018)) {
      this.tracker.push({ x, y });
    }

    this.lastPoint = point;
  }
}
