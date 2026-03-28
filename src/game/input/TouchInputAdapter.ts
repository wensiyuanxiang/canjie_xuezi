import type Phaser from "phaser";

import type { InputTracker } from "./InputTracker";

export class TouchInputAdapter {
  constructor(
    private readonly scene: Phaser.Scene,
    private readonly tracker: InputTracker,
  ) {}

  attach(): void {
    this.scene.input.on("pointerdown", (pointer: Phaser.Input.Pointer) => {
      this.tracker.begin({ x: pointer.x, y: pointer.y });
    });

    this.scene.input.on("pointermove", (pointer: Phaser.Input.Pointer) => {
      if (!pointer.isDown) {
        return;
      }

      this.tracker.push({ x: pointer.x, y: pointer.y });
    });

    this.scene.input.on("pointerup", () => {
      this.tracker.end();
    });

    this.scene.input.on("pointerupoutside", () => {
      this.tracker.end();
    });
  }
}
