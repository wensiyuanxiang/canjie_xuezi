import Phaser from "phaser";

import type { NormalizedHandPoint } from "../input/HandTrackingAdapter";
import { HandTrackingAdapter } from "../input/HandTrackingAdapter";
import { InputTracker } from "../input/InputTracker";
import { TouchInputAdapter } from "../input/TouchInputAdapter";
import { HitSystem } from "../systems/HitSystem";
import { ComboSystem } from "../systems/ComboSystem";
import { SlashTrail } from "../systems/SlashTrail";
import type { AppSettings, GameResult, LevelConfig } from "../../types/game";

interface SceneStone {
  id: number;
  char: string;
  isTarget: boolean;
  radius: number;
  vx: number;
  vy: number;
  sliced: boolean;
  container: Phaser.GameObjects.Container;
}

interface MountainLevelSceneConfig {
  level: LevelConfig;
  settings: AppSettings;
  getHandPoint: () => NormalizedHandPoint | null;
  onComplete: (result: GameResult) => void;
  onSlashCorrect: () => void;
  onSlashWrong: () => void;
  onComboUp: () => void;
  onBossComplete: () => void;
}

const SCENE_WIDTH = 390;
const SCENE_HEIGHT = 844;

export class MountainLevelScene extends Phaser.Scene {
  private readonly level: LevelConfig;

  private readonly settings: AppSettings;

  private readonly onComplete: (result: GameResult) => void;

  private readonly onSlashCorrect: () => void;

  private readonly onSlashWrong: () => void;

  private readonly onComboUp: () => void;

  private readonly onBossComplete: () => void;

  private readonly getHandPoint: () => NormalizedHandPoint | null;

  private readonly inputTracker = new InputTracker();

  private readonly hitSystem = new HitSystem();

  private readonly comboSystem = new ComboSystem();

  private readonly activeStones: SceneStone[] = [];

  private readonly spawnedQueue: string[] = [];

  private touchAdapter?: TouchInputAdapter;

  private handAdapter?: HandTrackingAdapter;

  private slashTrail?: SlashTrail;

  private spawnTimer?: Phaser.Time.TimerEvent;

  private countdownTimer?: Phaser.Time.TimerEvent;

  private objectiveText?: Phaser.GameObjects.Text;

  private statusText?: Phaser.GameObjects.Text;

  private comboText?: Phaser.GameObjects.Text;

  private timerText?: Phaser.GameObjects.Text;

  private promptText?: Phaser.GameObjects.Text;

  private bossText?: Phaser.GameObjects.Text;

  private bossGlow?: Phaser.GameObjects.Arc;

  private targetHits = 0;

  private wrongHits = 0;

  private misses = 0;

  private bossCharge = 0;

  private remainingSeconds: number;

  private finished = false;

  private stoneId = 0;

  private listenPromptChars: string[];

  private currentListenPrompt = 0;

  constructor(config: MountainLevelSceneConfig) {
    super("mountain-level");
    this.level = config.level;
    this.settings = config.settings;
    this.onComplete = config.onComplete;
    this.onSlashCorrect = config.onSlashCorrect;
    this.onSlashWrong = config.onSlashWrong;
    this.onComboUp = config.onComboUp;
    this.onBossComplete = config.onBossComplete;
    this.getHandPoint = config.getHandPoint;
    this.remainingSeconds = config.level.durationSec;
    this.listenPromptChars = config.level.targetChars.map((entry) => entry.char);
  }

  create(): void {
    this.cameras.main.setBackgroundColor("#00000000");
    this.addAtmosphere();
    this.createHud();
    this.prepareQueue();

    this.touchAdapter = new TouchInputAdapter(this, this.inputTracker);
    this.touchAdapter.attach();

    this.handAdapter = new HandTrackingAdapter(
      this.inputTracker,
      SCENE_WIDTH,
      SCENE_HEIGHT,
      this.settings.leftHandMode,
      this.settings.sensitivity,
    );

    this.slashTrail = new SlashTrail(this);

    this.spawnTimer = this.time.addEvent({
      delay: 780,
      loop: true,
      callback: () => {
        if (this.activeStones.length >= this.level.maxSimultaneous) {
          return;
        }

        this.spawnNextStone();
      },
    });

    this.countdownTimer = this.time.addEvent({
      delay: 1000,
      loop: true,
      callback: () => {
        this.remainingSeconds -= 1;
        this.updateHud();
        if (this.level.mode === "listen" && this.remainingSeconds % 4 === 0) {
          this.currentListenPrompt =
            (this.currentListenPrompt + 1) % Math.max(1, this.listenPromptChars.length);
          this.updatePrompt();
        }
        if (this.remainingSeconds <= 0) {
          this.finishLevel(false);
        }
      },
    });
  }

  update(_: number, delta: number): void {
    if (this.finished) {
      return;
    }

    if (this.settings.inputMode === "camera") {
      this.handAdapter?.update(this.getHandPoint());
    }

    this.activeStones.forEach((stone) => {
      stone.vy += delta * 0.00024;
      stone.container.x += stone.vx * (delta / 1000);
      stone.container.y += stone.vy * (delta / 1000);

      if (
        !stone.sliced &&
        (stone.container.y > SCENE_HEIGHT + 90 ||
          stone.container.x < -90 ||
          stone.container.x > SCENE_WIDTH + 90)
      ) {
        stone.sliced = true;
        stone.container.destroy();
        this.removeStone(stone.id);
        if (stone.isTarget) {
          this.misses += 1;
          this.updateHud();
        }
      }
    });

    const points = this.inputTracker.getPoints();
    this.slashTrail?.render(points, this.comboSystem.isEmpowered());

    if (points.length >= 2) {
      this.activeStones.forEach((stone) => {
        if (stone.sliced) {
          return;
        }

        const wasHit = this.hitSystem.wasHit(points, {
          x: stone.container.x,
          y: stone.container.y,
          radius: stone.radius,
        });

        if (!wasHit) {
          return;
        }

        this.resolveStoneHit(stone);
      });
    }

    if (!this.inputTracker.isActive() && points.length > 0) {
      this.inputTracker.clear();
      this.slashTrail?.render([], false);
    }
  }

  private addAtmosphere(): void {
    this.add
      .ellipse(80, 180, 180, 140, 0xf7e5b7, 0.14)
      .setBlendMode(Phaser.BlendModes.SCREEN);
    this.add
      .ellipse(310, 280, 160, 120, 0xa1c7b8, 0.12)
      .setBlendMode(Phaser.BlendModes.SCREEN);
    this.add.rectangle(195, 460, 350, 420, 0xffffff, 0.025).setStrokeStyle(1, 0xf1d8a3, 0.1);
  }

  private createHud(): void {
    const textStyle: Phaser.Types.GameObjects.Text.TextStyle = {
      fontFamily: '"Noto Serif SC", serif',
      color: "#2d3436",
      fontSize: "18px",
    };

    this.objectiveText = this.add.text(30, 30, this.level.title, {
      ...textStyle,
      fontSize: "30px",
      fontFamily: '"ZCOOL XiaoWei", serif',
    });

    this.promptText = this.add.text(30, 68, this.level.objectiveText, {
      ...textStyle,
      color: "#6f6452",
      wordWrap: { width: 250 },
    });

    this.timerText = this.add.text(286, 34, `${this.remainingSeconds}s`, {
      ...textStyle,
      fontSize: "24px",
      color: "#7f5419",
    });

    this.comboText = this.add.text(286, 66, "连切 0", {
      ...textStyle,
      fontSize: "20px",
      color: "#af7e20",
    });

    this.statusText = this.add.text(30, 126, "", {
      ...textStyle,
      color: "#6f6452",
      fontSize: "16px",
    });

    if (this.level.mode === "boss") {
      this.bossGlow = this.add.circle(195, 368, 78, 0xf9d96d, 0.14);
      this.bossText = this.add.text(195, 368, this.level.bossChar ?? "林", {
        fontFamily: '"Noto Serif SC", serif',
        fontSize: "88px",
        color: "#90857a",
      });
      this.bossText.setOrigin(0.5);
    }

    this.updateHud();
  }

  private prepareQueue(): void {
    this.level.targetChars.forEach((entry) => {
      for (let index = 0; index < entry.count; index += 1) {
        this.spawnedQueue.push(entry.char);
      }
    });

    this.level.distractorChars.forEach((entry) => {
      for (let index = 0; index < entry.count; index += 1) {
        this.spawnedQueue.push(entry.char);
      }
    });

    Phaser.Utils.Array.Shuffle(this.spawnedQueue);
  }

  private spawnNextStone(): void {
    const char = this.spawnedQueue.shift();
    if (!char) {
      return;
    }

    const fromSide = Phaser.Math.Between(0, 2);
    let startX = Phaser.Math.Between(90, 300);
    let startY = SCENE_HEIGHT + 48;
    let velocityX = Phaser.Math.Between(-42, 42);
    let velocityY = Phaser.Math.Between(-330, -280);

    if (fromSide === 1) {
      startX = -32;
      startY = Phaser.Math.Between(420, 650);
      velocityX = Phaser.Math.Between(90, 130);
      velocityY = Phaser.Math.Between(-180, -120);
    } else if (fromSide === 2) {
      startX = SCENE_WIDTH + 32;
      startY = Phaser.Math.Between(420, 650);
      velocityX = Phaser.Math.Between(-130, -90);
      velocityY = Phaser.Math.Between(-180, -120);
    }

    const isTarget = this.isTargetChar(char);
    const halo = this.add.circle(0, 0, 40, isTarget ? 0xf7ca62 : 0x8ea7c4, isTarget ? 0.16 : 0.12);
    const stone = this.add.circle(0, 0, 34, isTarget ? 0xfff7e2 : 0xf2f4f8, 0.94);
    stone.setStrokeStyle(3, isTarget ? 0xcf9f3e : 0x7e96b2, 0.85);
    const glyph = this.add.text(0, 0, char, {
      fontFamily: '"Noto Serif SC", serif',
      fontSize: "42px",
      color: isTarget ? "#39250a" : "#38495d",
    });
    glyph.setOrigin(0.5);

    const container = this.add.container(startX, startY, [halo, stone, glyph]);
    container.setDepth(8);

    this.activeStones.push({
      id: this.stoneId,
      char,
      isTarget,
      radius: 34,
      vx: velocityX,
      vy: velocityY,
      sliced: false,
      container,
    });
    this.stoneId += 1;
  }

  private resolveStoneHit(stone: SceneStone): void {
    stone.sliced = true;
    this.removeStone(stone.id);

    this.tweens.add({
      targets: stone.container,
      scaleX: 1.3,
      scaleY: 0.55,
      alpha: 0,
      angle: Phaser.Math.Between(-18, 18),
      duration: 180,
      onComplete: () => stone.container.destroy(),
    });

    if (stone.isTarget) {
      this.targetHits += 1;
      const combo = this.comboSystem.increment();
      this.onSlashCorrect();
      if (combo > 1) {
        this.onComboUp();
      }

      if (this.level.mode === "boss") {
        this.bossCharge += 1;
        this.bossGlow?.setFillStyle(0xf8d76f, Math.min(0.14 + this.bossCharge * 0.05, 0.48));
        this.bossText?.setColor(this.bossCharge >= this.level.passCondition.count ? "#5a400d" : "#7a6b60");
      }
    } else {
      this.wrongHits += 1;
      this.comboSystem.reset();
      this.onSlashWrong();
    }

    this.updateHud();
    this.checkCompletion();
  }

  private removeStone(id: number): void {
    const index = this.activeStones.findIndex((stone) => stone.id === id);
    if (index >= 0) {
      this.activeStones.splice(index, 1);
    }
  }

  private isTargetChar(char: string): boolean {
    if (this.level.mode === "listen") {
      return char === this.listenPromptChars[this.currentListenPrompt];
    }

    return this.level.targetChars.some((entry) => entry.char === char);
  }

  private checkCompletion(): void {
    const needed = this.level.passCondition.count;
    const progress = this.level.mode === "boss" ? this.bossCharge : this.targetHits;
    if (progress >= needed) {
      if (this.level.mode === "boss") {
        this.onBossComplete();
      }
      this.finishLevel(true);
    }
  }

  private updateHud(): void {
    const required = this.level.passCondition.count;
    const value = this.level.mode === "boss" ? this.bossCharge : this.targetHits;
    this.statusText?.setText(
      `目标进度 ${value}/${required}  ·  切错 ${this.wrongHits}  ·  漏切 ${this.misses}`,
    );
    this.comboText?.setText(`连切 ${this.comboSystem.getCombo()}`);
    this.timerText?.setText(`${Math.max(0, this.remainingSeconds)}s`);
    this.updatePrompt();
  }

  private updatePrompt(): void {
    if (!this.promptText) {
      return;
    }

    if (this.level.mode === "listen") {
      const currentChar = this.listenPromptChars[this.currentListenPrompt] ?? "山";
      const pinyin = currentChar === "山" ? "shan" : "shui";
      this.promptText.setText(`字灵念到 “${pinyin}” 时，切中对应的字。`);
      return;
    }

    if (this.level.mode === "boss") {
      this.promptText.setText(`切中飞来的“木”，为中央的“${this.level.bossChar ?? "林"}”充能。`);
      return;
    }

    this.promptText.setText(this.level.objectiveText);
  }

  private finishLevel(cleared: boolean): void {
    if (this.finished) {
      return;
    }

    this.finished = true;
    this.spawnTimer?.remove(false);
    this.countdownTimer?.remove(false);
    this.inputTracker.clear();

    const result: GameResult = {
      levelId: this.level.id,
      cleared,
      targetHits: this.targetHits,
      wrongHits: this.wrongHits,
      misses: this.misses,
      maxCombo: this.comboSystem.getMaxCombo(),
      learnedChars: cleared ? this.level.newChars : [],
      repairPreview: this.level.repairPreview,
    };

    this.time.delayedCall(420, () => this.onComplete(result));
  }
}
