import type Phaser from "phaser";

import type { TrailPoint } from "../input/InputTracker";

export class SlashTrail {
  private readonly graphics: Phaser.GameObjects.Graphics;

  constructor(private readonly scene: Phaser.Scene) {
    this.graphics = this.scene.add.graphics();
    this.graphics.setDepth(20);
  }

  render(points: TrailPoint[], empowered: boolean): void {
    this.graphics.clear();

    if (points.length < 2) {
      return;
    }

    this.graphics.lineStyle(empowered ? 8 : 5, empowered ? 0xf9cf5c : 0xfff0b5, 0.95);
    this.graphics.beginPath();
    this.graphics.moveTo(points[0].x, points[0].y);

    points.slice(1).forEach((point) => {
      this.graphics.lineTo(point.x, point.y);
    });

    this.graphics.strokePath();

    const tip = points[points.length - 1];
    this.graphics.fillStyle(empowered ? 0xffd664 : 0xfff6d1, 0.95);
    this.graphics.fillCircle(tip.x, tip.y, empowered ? 9 : 7);
  }

  destroy(): void {
    this.graphics.destroy();
  }
}
