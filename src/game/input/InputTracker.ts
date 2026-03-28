export interface TrailPoint {
  x: number;
  y: number;
  time: number;
}

export class InputTracker {
  private points: TrailPoint[] = [];

  private active = false;

  begin(point: Omit<TrailPoint, "time">, time = performance.now()): void {
    this.active = true;
    this.points = [{ ...point, time }];
  }

  push(point: Omit<TrailPoint, "time">, time = performance.now()): void {
    if (!this.active) {
      this.begin(point, time);
      return;
    }

    const lastPoint = this.points[this.points.length - 1];
    const distance = Math.hypot(point.x - lastPoint.x, point.y - lastPoint.y);
    if (distance < 6) {
      return;
    }

    this.points.push({ ...point, time });
    this.trim(time);
  }

  end(): void {
    this.active = false;
  }

  clear(): void {
    this.points = [];
    this.active = false;
  }

  getPoints(): TrailPoint[] {
    return this.points;
  }

  isActive(): boolean {
    return this.active;
  }

  private trim(now: number): void {
    this.points = this.points.filter((point) => now - point.time <= 220);
  }
}
