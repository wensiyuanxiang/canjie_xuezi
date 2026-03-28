# 仓颉学字 - 技术实现拆解

日期：2026-03-28
目的：MVP 阶段的完整技术方案，精确到模块、数据流、关键代码模式。照着写就能跑。

---

## 一、整体架构：React 管页面，Phaser 管游戏

```
┌──────────────────────────────────────────────────┐
│                   React App                       │
│                                                   │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │ HomePage  │  │ WorldMap │  │ ResultScreen  │  │
│  │ (首页)    │  │ (地图)   │  │ (结算页)      │  │
│  └──────────┘  └──────────┘  └───────────────┘  │
│                                                   │
│  ┌───────────────────────────────────────────┐   │
│  │          GameScreen (React 容器)           │   │
│  │  ┌─────────────────────────────────────┐  │   │
│  │  │         Phaser 3 Canvas              │  │   │
│  │  │                                      │  │   │
│  │  │  BootScene → GameScene / BossScene   │  │   │
│  │  │                                      │  │   │
│  │  └─────────────────────────────────────┘  │   │
│  │  ┌─────────────────────────────────────┐  │   │
│  │  │    HUD Overlay (React DOM 叠加层)    │  │   │
│  │  │    目标字提示 / 字灵气泡 / 暂停按钮   │  │   │
│  │  └─────────────────────────────────────┘  │   │
│  └───────────────────────────────────────────┘   │
│                                                   │
│  ┌───────────────────────────────────────────┐   │
│  │         GameStore (Zustand)                │   │
│  │  进度、字库、关卡状态、combo、设置         │   │
│  └───────────────────────────────────────────┘   │
└──────────────────────────────────────────────────┘
```

**核心原则**：Phaser 只负责画面和物理，所有持久状态放在 React 侧（Zustand），两者通过 EventEmitter 通信。这样 UI 页面（首页、地图、结算）全用 React 写，可以充分利用 CSS/Tailwind 做精美 UI，不受 Phaser UI 能力的限制。

---

## 二、React 与 Phaser 通信

### 2.1 EventBus 桥接

```typescript
// src/game/EventBus.ts
import { EventEmitter } from 'eventemitter3';

export const GameEvents = {
  CHAR_CAUGHT_CORRECT: 'char:caught:correct',
  CHAR_CAUGHT_WRONG: 'char:caught:wrong',
  CHAR_MISSED: 'char:missed',
  COMBO_UPDATE: 'combo:update',
  LEVEL_COMPLETE: 'level:complete',
  LEVEL_FAILED: 'level:failed',
  BOSS_MERGE: 'boss:merge',
  ABILITY_TRIGGERED: 'ability:triggered',
  SCENE_READY: 'scene:ready',
} as const;

export const eventBus = new EventEmitter();
```

### 2.2 数据流方向

```
React → Phaser（启动/配置）:
  GameScreen 组件创建 Phaser.Game 实例
  传入当前关卡配置（JSON）
  传入已解锁能力列表

Phaser → React（事件回调）:
  eventBus.emit('char:caught:correct', { char: '山', combo: 3 })
  eventBus.emit('level:complete', { stats: {...} })

React 监听事件 → 更新 Zustand Store → UI 自动响应
```

### 2.3 GameScreen 容器组件

```typescript
// src/components/GameScreen.tsx（核心骨架）
import { useEffect, useRef } from 'react';
import Phaser from 'phaser';
import { BootScene } from '../game/scenes/BootScene';
import { GameScene } from '../game/scenes/GameScene';
import { eventBus, GameEvents } from '../game/EventBus';
import { useGameStore } from '../store/gameStore';
import { HUD } from './HUD';

interface Props {
  levelConfig: LevelConfig;
  onLevelEnd: (result: LevelResult) => void;
}

export function GameScreen({ levelConfig, onLevelEnd }: Props) {
  const gameRef = useRef<Phaser.Game | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const config: Phaser.Types.Core.GameConfig = {
      type: Phaser.AUTO,
      parent: containerRef.current,
      width: 540,
      height: 960,
      scale: {
        mode: Phaser.Scale.FIT,
        autoCenter: Phaser.Scale.CENTER_BOTH,
      },
      physics: {
        default: 'arcade',
        arcade: { gravity: { x: 0, y: 0 }, debug: false },
      },
      scene: [BootScene, GameScene],
      backgroundColor: '#F5F0E8',
    };

    gameRef.current = new Phaser.Game(config);

    // 资源加载完成后，启动 GameScene 并传入关卡配置
    eventBus.on(GameEvents.SCENE_READY, () => {
      gameRef.current?.scene.start('GameScene', { levelConfig });
    });

    // 监听关卡结束
    eventBus.on(GameEvents.LEVEL_COMPLETE, onLevelEnd);

    return () => {
      eventBus.removeAllListeners();
      gameRef.current?.destroy(true);
    };
  }, [levelConfig]);

  return (
    <div style={{ position: 'relative' }}>
      <div ref={containerRef} />
      <HUD /> {/* React DOM 叠加在 Phaser Canvas 上 */}
    </div>
  );
}
```

---

## 三、Phaser 场景拆解

### 3.1 场景生命周期

```
BootScene          GameScene               React
  │                   │                      │
  ├─ preload()        │                      │
  │  加载所有图片/音效  │                      │
  │                   │                      │
  ├─ create()         │                      │
  │  emit SCENE_READY │                      │
  │                   │                      │
  │                   ├─ init(levelConfig)    │
  │                   │  接收关卡配置          │
  │                   │                      │
  │                   ├─ create()             │
  │                   │  创建背景/接收区/字灵  │
  │                   │  启动生成定时器        │
  │                   │  启动关卡计时器        │
  │                   │                      │
  │                   ├─ update(delta)        │
  │                   │  每帧：               │
  │                   │  - 天气效果更新        │
  │                   │  - 碰撞检测           │
  │                   │  - 出界检测           │
  │                   │  - 计时器倒计时        │
  │                   │                      │
  │                   ├─ 关卡结束             │
  │                   │  emit LEVEL_COMPLETE ──→ 收到事件
  │                   │                      │  切换到 ResultScreen
```

### 3.2 BootScene - 资源预加载

```typescript
// src/game/scenes/BootScene.ts
export class BootScene extends Phaser.Scene {
  constructor() {
    super('BootScene');
  }

  preload() {
    // 背景
    this.load.image('bg-mountain-gray', '/assets/images/bg/bg-mountain-gray.png');
    this.load.image('bg-mountain-color', '/assets/images/bg/bg-mountain-color.png');

    // 角色
    this.load.image('zilin-neutral', '/assets/images/character/zilin-neutral.png');
    this.load.image('zilin-happy', '/assets/images/character/zilin-happy.png');
    this.load.image('zilin-sad', '/assets/images/character/zilin-sad.png');
    this.load.image('catcher', '/assets/images/character/catcher.png');

    // 游戏元素
    this.load.image('char-bg-target', '/assets/images/game/char-bg-target.png');
    this.load.image('char-bg-distractor', '/assets/images/game/char-bg-distractor.png');

    // 粒子
    this.load.image('particle-star', '/assets/images/particle/particle-star.png');
    this.load.image('particle-glow', '/assets/images/particle/particle-glow.png');

    // 音效
    this.load.audio('bgm-mountain', '/assets/audio/bgm/bgm-mountain.mp3');
    this.load.audio('sfx-catch-correct', '/assets/audio/sfx/sfx-catch-correct.mp3');
    this.load.audio('sfx-catch-wrong', '/assets/audio/sfx/sfx-catch-wrong.mp3');
    this.load.audio('sfx-combo-3', '/assets/audio/sfx/sfx-combo-3.mp3');
    this.load.audio('sfx-level-clear', '/assets/audio/sfx/sfx-level-clear.mp3');
  }

  create() {
    eventBus.emit(GameEvents.SCENE_READY);
  }
}
```

### 3.3 GameScene - 核心游戏场景

```
GameScene 内部对象结构：

┌─────────────────────────────────────────┐
│              GameScene                   │
│                                          │
│  ┌─────────┐  ┌──────────────────────┐  │
│  │ 背景层   │  │ 游戏层               │  │
│  │ depth:0  │  │ depth:1-10           │  │
│  │          │  │                      │  │
│  │ bg-gray  │  │ fallingChars: Group  │  │
│  │ bg-color │  │ catcher: Sprite      │  │
│  │ (叠加)   │  │ particles: Emitter   │  │
│  └─────────┘  └──────────────────────┘  │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ 系统                              │   │
│  │ SpawnSystem   - 定时生成字         │   │
│  │ ComboSystem   - 连击计数+特效      │   │
│  │ WeatherSystem - 下落轨迹修改       │   │
│  │ LevelTimer    - 关卡倒计时         │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## 四、核心游戏对象实现

### 4.1 FallingChar - 下落字

```typescript
// src/game/objects/FallingChar.ts
interface FallingCharConfig {
  char: string;
  type: 'target' | 'distractor' | 'ability';
  fallSpeed: number;
  scene: Phaser.Scene;
}

export class FallingChar extends Phaser.GameObjects.Container {
  public charText: Phaser.GameObjects.Text;
  public charType: 'target' | 'distractor' | 'ability';
  public charValue: string;

  constructor(config: FallingCharConfig) {
    const x = Phaser.Math.Between(40, 500); // 随机 x 位置
    super(config.scene, x, -60);

    this.charValue = config.char;
    this.charType = config.type;

    // 底板光晕
    const bgKey = config.type === 'target' ? 'char-bg-target'
                : config.type === 'ability' ? 'char-bg-ability'
                : 'char-bg-distractor';
    const bg = config.scene.add.image(0, 0, bgKey);
    this.add(bg);

    // 汉字文本
    this.charText = config.scene.add.text(0, 0, config.char, {
      fontFamily: 'Noto Sans SC',
      fontSize: '42px',
      fontStyle: 'bold',
      color: config.type === 'target' ? '#2D3436' : '#636E72',
      align: 'center',
    }).setOrigin(0.5);
    this.add(this.charText);

    config.scene.add.existing(this);
    config.scene.physics.add.existing(this);

    // 设置物理体和下落速度
    const body = this.body as Phaser.Physics.Arcade.Body;
    body.setSize(70, 70);
    body.setVelocityY(config.fallSpeed);
  }
}
```

### 4.2 Catcher - 接收区

```typescript
// src/game/objects/Catcher.ts
export class Catcher extends Phaser.GameObjects.Sprite {
  private targetX: number;

  constructor(scene: Phaser.Scene) {
    super(scene, 270, 880, 'catcher');
    this.targetX = 270;

    scene.add.existing(this);
    scene.physics.add.existing(this, false);

    const body = this.body as Phaser.Physics.Arcade.Body;
    body.setImmovable(true);
    body.setSize(140, 60);
    body.setCollideWorldBounds(true);
  }

  // 触摸/鼠标移动控制
  moveTo(x: number) {
    this.targetX = Phaser.Math.Clamp(x, 80, 460);
  }

  update() {
    // 平滑追踪目标位置
    this.x = Phaser.Math.Linear(this.x, this.targetX, 0.2);
    (this.body as Phaser.Physics.Arcade.Body).updateFromGameObject();
  }
}
```

### 4.3 输入控制

```typescript
// 在 GameScene.create() 中设置输入
setupInput() {
  // 触摸/鼠标：指哪去哪
  this.input.on('pointermove', (pointer: Phaser.Input.Pointer) => {
    this.catcher.moveTo(pointer.x);
  });

  // 键盘备选
  this.cursors = this.input.keyboard!.createCursorKeys();
}

// 在 GameScene.update() 中处理键盘
if (this.cursors.left.isDown) {
  this.catcher.moveTo(this.catcher.x - 8);
} else if (this.cursors.right.isDown) {
  this.catcher.moveTo(this.catcher.x + 8);
}
```

---

## 五、核心系统实现

### 5.1 SpawnSystem - 字生成器

```typescript
// src/game/systems/SpawnSystem.ts
export class SpawnSystem {
  private scene: Phaser.Scene;
  private config: LevelConfig;
  private spawnQueue: SpawnItem[];
  private spawnTimer: Phaser.Time.TimerEvent;
  private spawned: number = 0;

  constructor(scene: Phaser.Scene, config: LevelConfig) {
    this.scene = scene;
    this.config = config;
    this.spawnQueue = this.buildQueue(config);

    // 计算生成间隔：总时长 / 总掉落数
    const interval = (config.duration_sec * 1000) / this.spawnQueue.length;

    this.spawnTimer = scene.time.addEvent({
      delay: interval,
      callback: this.spawnNext,
      callbackScope: this,
      repeat: this.spawnQueue.length - 1,
    });
  }

  // 根据关卡配置构建生成队列
  private buildQueue(config: LevelConfig): SpawnItem[] {
    const queue: SpawnItem[] = [];

    for (const tc of config.target_chars) {
      for (let i = 0; i < tc.count; i++) {
        queue.push({ char: tc.char, type: 'target' });
      }
    }
    for (const dc of config.distractor_chars) {
      for (let i = 0; i < dc.count; i++) {
        queue.push({ char: dc.char, type: 'distractor' });
      }
    }

    // 随机打乱顺序
    Phaser.Utils.Array.Shuffle(queue);

    // 但确保不连续出现 3 个以上同类型（避免太容易/太难的连续段）
    return this.balanceQueue(queue);
  }

  private spawnNext() {
    if (this.spawned >= this.spawnQueue.length) return;

    const item = this.spawnQueue[this.spawned];

    // 同屏数量限制
    const activeCount = this.scene.children.list.filter(
      c => c instanceof FallingChar
    ).length;
    if (activeCount >= this.config.max_simultaneous) return;

    const fallSpeed = (960 / this.config.fall_speed) ; // fall_speed 是到底秒数

    const char = new FallingChar({
      scene: this.scene,
      char: item.char,
      type: item.type,
      fallSpeed,
    });

    this.scene.fallingChars.add(char);
    this.spawned++;
  }
}
```

### 5.2 碰撞检测 & 判定

```typescript
// 在 GameScene.create() 中设置碰撞
this.physics.add.overlap(
  this.catcher,
  this.fallingChars,
  this.onCatchChar,
  undefined,
  this
);

// 碰撞回调
onCatchChar(
  catcher: Phaser.GameObjects.GameObject,
  charObj: Phaser.GameObjects.GameObject
) {
  const fallingChar = charObj as FallingChar;

  if (fallingChar.charType === 'target') {
    this.onCorrectCatch(fallingChar);
  } else if (fallingChar.charType === 'ability') {
    this.onAbilityCatch(fallingChar);
  } else {
    this.onWrongCatch(fallingChar);
  }
}

onCorrectCatch(char: FallingChar) {
  this.comboSystem.increment();
  this.stats.correct++;
  this.effectsManager.playCatchCorrect(char);
  this.sound.play('sfx-catch-correct');
  eventBus.emit(GameEvents.CHAR_CAUGHT_CORRECT, {
    char: char.charValue,
    combo: this.comboSystem.count,
  });
  char.destroy();
}

onWrongCatch(char: FallingChar) {
  this.comboSystem.reset();
  this.effectsManager.playCatchWrong(char);
  this.sound.play('sfx-catch-wrong');
  eventBus.emit(GameEvents.CHAR_CAUGHT_WRONG, { char: char.charValue });
  char.destroy();
}
```

### 5.3 出界检测 & 漏接

```typescript
// 在 GameScene.update() 中每帧检查
this.fallingChars.getChildren().forEach((child) => {
  const char = child as FallingChar;
  if (char.y > 980) { // 超出屏幕底部
    if (char.charType === 'target') {
      this.stats.missed++;
      this.missedChars.push(char.charValue);
      eventBus.emit(GameEvents.CHAR_MISSED, { char: char.charValue });
    }
    char.destroy();
  }
});
```

### 5.4 ComboSystem - 连击

```typescript
// src/game/systems/ComboSystem.ts
export class ComboSystem {
  public count: number = 0;
  private scene: Phaser.Scene;

  constructor(scene: Phaser.Scene) {
    this.scene = scene;
  }

  increment() {
    this.count++;
    eventBus.emit(GameEvents.COMBO_UPDATE, { combo: this.count });

    if (this.count === 3) this.onCombo3();
    if (this.count === 5) this.onCombo5();
    if (this.count === 10) this.onCombo10();
  }

  reset() {
    if (this.count > 0) {
      this.count = 0;
      eventBus.emit(GameEvents.COMBO_UPDATE, { combo: 0 });
      this.scene.cameras.main.resetPostPipeline();
    }
  }

  private onCombo3() {
    // 屏幕边缘闪光 → 见特效章节
    this.scene.sound.play('sfx-combo-3');
  }

  private onCombo5() {
    // BGM 叠加鼓点层 → 见音效章节
  }

  private onCombo10() {
    // 全屏慢动作 2 秒
    this.scene.time.timeScale = 0.3;
    this.scene.time.delayedCall(2000, () => {
      this.scene.time.timeScale = 1;
    });
  }
}
```

### 5.5 LevelManager - 关卡流程控制

```typescript
// src/game/systems/LevelManager.ts
export class LevelManager {
  private config: LevelConfig;
  private scene: Phaser.Scene;
  private timeLeft: number;
  private stats: LevelStats = { correct: 0, wrong: 0, missed: 0 };

  start() {
    this.timeLeft = this.config.duration_sec;

    this.scene.time.addEvent({
      delay: 1000,
      callback: () => {
        this.timeLeft--;
        if (this.timeLeft <= 0) this.endLevel();
      },
      repeat: this.config.duration_sec - 1,
    });
  }

  endLevel() {
    const passed = this.checkPassCondition();
    const rating = this.calculateRating();

    eventBus.emit(GameEvents.LEVEL_COMPLETE, {
      passed,
      rating,           // 'seed' | 'sprout' | 'tree'
      stats: this.stats,
      newChars: this.config.new_chars,
      missedChars: this.missedChars,
    });
  }

  private checkPassCondition(): boolean {
    const cond = this.config.pass_condition;
    if (cond.type === 'catch_count') {
      if (cond.char) {
        return this.stats.correctByChar[cond.char] >= cond.count;
      }
      return this.stats.correct >= cond.total;
    }
    return false;
  }

  private calculateRating(): 'seed' | 'sprout' | 'tree' {
    const total = this.stats.correct + this.stats.missed;
    const rate = total > 0 ? this.stats.correct / total : 0;

    if (rate >= 0.9 && this.stats.wrong === 0) return 'tree';
    if (rate >= 0.7) return 'sprout';
    return 'seed';
  }
}
```

### 5.6 WeatherSystem - 天气效果

```typescript
// src/game/systems/WeatherSystem.ts
export class WeatherSystem {
  applyToChar(char: FallingChar, weather: string) {
    const body = char.body as Phaser.Physics.Arcade.Body;

    switch (weather) {
      case 'clear':
        break; // 直线下落，不修改

      case 'breeze':
        // 微风：正弦波左右飘移
        char.scene.tweens.add({
          targets: char,
          x: char.x + Phaser.Math.Between(-40, 40),
          duration: 1000,
          yoyo: true,
          repeat: -1,
          ease: 'Sine.easeInOut',
        });
        break;

      case 'rain':
        // 大雨：加速但字更大
        body.setVelocityY(body.velocity.y * 1.5);
        char.setScale(1.3);
        break;

      case 'snow':
        // 飘雪：减速 + 随机飘移
        body.setVelocityY(body.velocity.y * 0.6);
        char.scene.tweens.add({
          targets: char,
          x: char.x + Phaser.Math.Between(-60, 60),
          duration: 2000,
          yoyo: true,
          repeat: -1,
          ease: 'Sine.easeInOut',
        });
        break;

      case 'whirlwind':
        // 旋风：旋转下落
        char.scene.tweens.add({
          targets: char,
          angle: 360,
          duration: 1500,
          repeat: -1,
        });
        break;
    }
  }
}
```

---

## 六、特效系统（重点）

### 6.1 特效总览

```
接住目标字
├── 字放大 + 透明消失        → Tween
├── 飞入底部收集栏            → Tween (抛物线)
├── 落点爆发星星粒子          → Particle Emitter
└── 屏幕微震                 → Camera shake

接住干扰字
├── 字抖动 + 碎裂消失         → Tween + 墨点粒子
└── 字灵切换惋惜表情          → Sprite texture swap

Combo 3
└── 屏幕边缘金色辉光          → 矩形遮罩 + Tween alpha

Combo 5
└── BGM 叠加鼓点层            → 播放第二音轨

Combo 10
└── 全屏慢动作 2 秒           → scene.time.timeScale = 0.3

BOSS 拼合
├── 组件飞向中心              → Tween
├── 碰撞闪光                 → 白色全屏 flash
└── 合体字放大显现            → Tween scale + 粒子爆发

场景灰→彩色
└── 背景饱和度渐变            → 叠加两层背景 + alpha 渐变

能力·焚字
├── 所有干扰字燃烧消失        → 逐个 Tween + 火焰粒子
└── 屏幕暖色闪烁             → Camera flash
```

### 6.2 接住目标字 - 完整特效代码

```typescript
playCatchCorrect(char: FallingChar) {
  const { x, y } = char;

  // 1. 星星粒子爆发
  this.starEmitter.emitParticleAt(x, y, 8);

  // 2. 字放大 + 上浮 + 消失
  const flyingText = this.scene.add.text(x, y, char.charValue, {
    fontFamily: 'Noto Sans SC',
    fontSize: '42px',
    fontStyle: 'bold',
    color: '#FF9F43',
  }).setOrigin(0.5).setDepth(20);

  this.scene.tweens.add({
    targets: flyingText,
    scaleX: 1.8,
    scaleY: 1.8,
    y: y - 40,
    alpha: 0.8,
    duration: 200,
    ease: 'Back.easeOut',
    onComplete: () => {
      // 3. 飞入底部收集栏（抛物线）
      this.scene.tweens.add({
        targets: flyingText,
        x: 480,      // 收集栏 x
        y: 920,      // 收集栏 y
        scaleX: 0.5,
        scaleY: 0.5,
        alpha: 0,
        duration: 400,
        ease: 'Cubic.easeIn',
        onComplete: () => flyingText.destroy(),
      });
    },
  });

  // 4. 摄像机微震
  this.scene.cameras.main.shake(80, 0.005);
}
```

### 6.3 Combo 3 - 屏幕边缘辉光

```typescript
// create() 中创建辉光遮罩（初始透明）
this.comboGlow = this.scene.add.rectangle(270, 480, 540, 960)
  .setStrokeStyle(30, 0xFFD93D, 0)  // 金色边框，初始透明
  .setDepth(15)
  .setAlpha(0);

// combo 3 触发
onCombo3() {
  this.scene.tweens.add({
    targets: this.comboGlow,
    alpha: 0.6,
    duration: 200,
    yoyo: true,
    repeat: 2,
    ease: 'Sine.easeInOut',
  });
}
```

### 6.4 Combo 10 - 全屏慢动作

```typescript
onCombo10() {
  // 时间缩放
  this.scene.physics.world.timeScale = 3;  // 物理减速（值越大越慢）
  this.scene.time.timeScale = 0.3;          // 逻辑减速

  // 视觉效果：轻微放大 + 暗角
  this.scene.cameras.main.zoomTo(1.05, 300);

  // 2 秒后恢复
  this.scene.time.delayedCall(600, () => { // 600ms 实际 = 2s 感知
    this.scene.physics.world.timeScale = 1;
    this.scene.time.timeScale = 1;
    this.scene.cameras.main.zoomTo(1, 300);
  });
}
```

### 6.5 粒子系统设置

```typescript
// create() 中初始化粒子发射器
setupParticles() {
  // 星星粒子（接住目标字、combo）
  this.starEmitter = this.add.particles(0, 0, 'particle-star', {
    speed: { min: 100, max: 250 },
    scale: { start: 0.8, end: 0 },
    alpha: { start: 1, end: 0 },
    lifespan: 500,
    gravityY: 200,
    emitting: false,          // 手动触发，不自动发射
  });
  this.starEmitter.setDepth(18);

  // 辉光粒子（持续跟随接收区）
  this.glowEmitter = this.add.particles(0, 0, 'particle-glow', {
    follow: this.catcher,
    speed: 20,
    scale: { start: 0.5, end: 0 },
    alpha: { start: 0.3, end: 0 },
    lifespan: 300,
    frequency: 100,
    blendMode: 'ADD',
  });
  this.glowEmitter.setDepth(1);

  // 墨点粒子（接错碎裂）
  this.inkEmitter = this.add.particles(0, 0, 'particle-ink', {
    speed: { min: 50, max: 150 },
    scale: { start: 0.6, end: 0 },
    lifespan: 400,
    gravityY: 300,
    emitting: false,
  });
}
```

### 6.6 场景灰→彩色过渡

```typescript
// 两层背景叠加，通过 alpha 控制过渡
setupBackground() {
  // 底层：灰白版（始终显示）
  this.bgGray = this.add.image(270, 480, 'bg-mountain-gray')
    .setDisplaySize(540, 960)
    .setDepth(0);

  // 顶层：彩色版（初始透明）
  this.bgColor = this.add.image(270, 480, 'bg-mountain-color')
    .setDisplaySize(540, 960)
    .setDepth(0)
    .setAlpha(0);
}

// 每学会一个新字，彩色层 alpha 增加一点
onNewCharLearned(charCount: number, totalInWorld: number) {
  const progress = charCount / totalInWorld; // 0 → 1
  this.tweens.add({
    targets: this.bgColor,
    alpha: progress,
    duration: 1500,
    ease: 'Sine.easeInOut',
  });
}

// 世界通关时一次性全彩
onWorldComplete() {
  this.tweens.add({
    targets: this.bgColor,
    alpha: 1,
    duration: 3000,
    ease: 'Cubic.easeInOut',
  });
  this.sound.play('sfx-scene-reveal');
  this.cameras.main.flash(1000, 255, 255, 255, false, (_, progress) => {
    if (progress === 1) {
      this.starEmitter.emitParticleAt(270, 480, 30);
    }
  });
}
```

### 6.7 BOSS 拆字拼合

```typescript
// BossScene 或 GameScene 中的 BOSS 模式
setupBoss(bossChar: string, components: string[]) {
  // 中央显示大字（半透明灰色）
  this.bossText = this.add.text(270, 200, bossChar, {
    fontSize: '120px', fontFamily: 'Noto Sans SC', fontStyle: 'bold',
    color: '#CCCCCC',
  }).setOrigin(0.5).setAlpha(0.3).setDepth(5);

  // 底部显示需要收集的组件提示
  this.componentSlots = components.map((comp, i) => {
    return this.add.text(200 + i * 140, 750, '?', {
      fontSize: '48px', color: '#FFD93D',
    }).setOrigin(0.5);
  });

  this.collectedComponents = [];
}

onBossComponentCaught(char: FallingChar) {
  const idx = this.collectedComponents.length;
  this.collectedComponents.push(char.charValue);

  // 组件文字飞向对应槽位
  const slot = this.componentSlots[idx];
  const flyText = this.add.text(char.x, char.y, char.charValue, {
    fontSize: '48px', fontFamily: 'Noto Sans SC', color: '#FFD93D',
  }).setOrigin(0.5);

  this.tweens.add({
    targets: flyText,
    x: slot.x,
    y: slot.y,
    duration: 500,
    ease: 'Back.easeIn',
    onComplete: () => {
      slot.setText(char.charValue);
      flyText.destroy();

      // 全部收集完 → 拼合动画
      if (this.collectedComponents.length === this.componentSlots.length) {
        this.playMergeAnimation();
      }
    },
  });
}

playMergeAnimation() {
  // 所有组件飞向中央 BOSS 字
  this.componentSlots.forEach((slot, i) => {
    this.tweens.add({
      targets: slot,
      x: 270,
      y: 200,
      alpha: 0,
      duration: 600,
      delay: i * 150,
      ease: 'Cubic.easeIn',
    });
  });

  // 延迟后 BOSS 字变亮
  this.time.delayedCall(800, () => {
    this.cameras.main.flash(500, 255, 215, 0); // 金色闪光
    this.bossText.setColor('#FF9F43').setAlpha(1);

    this.tweens.add({
      targets: this.bossText,
      scaleX: 1.5, scaleY: 1.5,
      duration: 300,
      yoyo: true,
      ease: 'Back.easeOut',
    });

    this.starEmitter.emitParticleAt(270, 200, 20);
    this.sound.play('sfx-boss-merge');

    eventBus.emit(GameEvents.BOSS_MERGE, { char: this.bossText.text });
  });
}
```

---

## 七、世界/关卡数据设计

### 7.1 数据文件结构

```
src/data/
├── characters.json      # 字库（MVP：~15 个字）
├── levels/
│   └── epoch1/
│       └── mountain.json # 山野世界关卡配置（6 关）
└── worlds.json          # 世界元数据（解锁条件、背景资源映射）
```

### 7.2 worlds.json - 世界注册表

```json
{
  "epochs": [
    {
      "id": 1,
      "name": "万物有形",
      "unlock": { "type": "default" },
      "worlds": [
        {
          "id": "mountain",
          "name": "山野",
          "theme": "nature",
          "bgGray": "bg-mountain-gray",
          "bgColor": "bg-mountain-color",
          "bgm": "bgm-mountain",
          "defaultWeather": "clear",
          "totalChars": 8,
          "levelsFile": "levels/epoch1/mountain.json",
          "unlock": { "type": "default" }
        },
        {
          "id": "sky",
          "name": "天穹",
          "theme": "celestial",
          "bgGray": "bg-sky-gray",
          "bgColor": "bg-sky-color",
          "bgm": "bgm-sky",
          "defaultWeather": "rain",
          "totalChars": 8,
          "levelsFile": "levels/epoch1/sky.json",
          "unlock": { "type": "world_clear", "requires": "mountain" }
        }
      ]
    }
  ]
}
```

### 7.3 山野关卡配置（MVP 6 关）

```json
[
  {
    "level": 1,
    "mode": "recognize_shape",
    "duration_sec": 45,
    "new_chars": ["山"],
    "target_chars": [{"char": "山", "count": 8}],
    "distractor_chars": [],
    "fall_speed": 3.0,
    "max_simultaneous": 1,
    "weather": "clear",
    "pass_condition": {"type": "catch_count", "char": "山", "count": 5},
    "tutorial": true
  },
  {
    "level": 2,
    "mode": "recognize_shape",
    "duration_sec": 60,
    "new_chars": ["水"],
    "target_chars": [{"char": "水", "count": 10}],
    "distractor_chars": [{"char": "山", "count": 10}],
    "fall_speed": 2.5,
    "max_simultaneous": 2,
    "weather": "clear",
    "pass_condition": {"type": "catch_count", "char": "水", "count": 6}
  },
  {
    "level": 3,
    "mode": "listen_catch",
    "duration_sec": 60,
    "new_chars": [],
    "target_chars": [{"char": "山", "count": 6}, {"char": "水", "count": 6}],
    "distractor_chars": [{"char": "出", "count": 4}, {"char": "永", "count": 4}],
    "fall_speed": 2.5,
    "max_simultaneous": 2,
    "weather": "clear",
    "pass_condition": {"type": "catch_count", "total": 8}
  },
  {
    "level": 4,
    "mode": "recognize_shape",
    "duration_sec": 75,
    "new_chars": ["火", "木"],
    "target_chars": [{"char": "火", "count": 7}, {"char": "木", "count": 7}],
    "distractor_chars": [{"char": "山", "count": 4}, {"char": "水", "count": 4}, {"char": "大", "count": 3}],
    "fall_speed": 2.5,
    "max_simultaneous": 2,
    "weather": "breeze",
    "pass_condition": {"type": "catch_each", "chars": {"火": 4, "木": 4}}
  },
  {
    "level": 5,
    "mode": "recognize_shape",
    "duration_sec": 75,
    "new_chars": ["土"],
    "target_chars": [{"char": "土", "count": 8}, {"char": "山", "count": 4}],
    "distractor_chars": [{"char": "水", "count": 4}, {"char": "火", "count": 4}, {"char": "王", "count": 4}],
    "fall_speed": 2.0,
    "max_simultaneous": 3,
    "weather": "breeze",
    "pass_condition": {"type": "catch_count", "char": "土", "count": 5}
  },
  {
    "level": 6,
    "mode": "boss_merge",
    "duration_sec": 90,
    "new_chars": ["林"],
    "boss_char": "林",
    "boss_components": ["木", "木"],
    "target_chars": [{"char": "木", "count": 12}],
    "distractor_chars": [{"char": "山", "count": 6}, {"char": "水", "count": 6}, {"char": "火", "count": 6}],
    "fall_speed": 2.0,
    "max_simultaneous": 3,
    "weather": "clear",
    "pass_condition": {"type": "boss_merge", "count": 3}
  }
]
```

### 7.4 字库 characters.json（MVP 子集）

```json
[
  {
    "char": "山", "pinyin": "shān", "radical": "山",
    "stroke_count": 3, "grade": 1, "epoch": 1, "world": "mountain",
    "char_type": "noun", "category": "nature",
    "words": ["山水", "火山", "山林"],
    "sentence": "远处有一座高高的山。",
    "similar_chars": ["出", "岁"],
    "ability": null,
    "composites": ["岩=山+石"]
  },
  {
    "char": "水", "pinyin": "shuǐ", "radical": "水",
    "stroke_count": 4, "grade": 1, "epoch": 1, "world": "mountain",
    "char_type": "noun", "category": "nature",
    "words": ["山水", "水火", "大水"],
    "sentence": "河里的水清清的。",
    "similar_chars": ["永", "泉"],
    "ability": { "name": "引流", "effect": "target_auto_guide" },
    "composites": []
  },
  {
    "char": "火", "pinyin": "huǒ", "radical": "火",
    "stroke_count": 4, "grade": 1, "epoch": 1, "world": "mountain",
    "char_type": "noun", "category": "nature",
    "words": ["火山", "大火", "火车"],
    "sentence": "冬天的火很暖和。",
    "similar_chars": ["灭"],
    "ability": { "name": "焚字", "effect": "burn_distractors" },
    "composites": []
  },
  {
    "char": "木", "pinyin": "mù", "radical": "木",
    "stroke_count": 4, "grade": 1, "epoch": 1, "world": "mountain",
    "char_type": "noun", "category": "nature",
    "words": ["木头", "树木", "木马"],
    "sentence": "院子里有一棵大树木。",
    "similar_chars": ["本", "术"],
    "ability": null,
    "composites": ["林=木+木", "森=木+木+木"]
  },
  {
    "char": "土", "pinyin": "tǔ", "radical": "土",
    "stroke_count": 3, "grade": 1, "epoch": 1, "world": "mountain",
    "char_type": "noun", "category": "nature",
    "words": ["土地", "泥土", "国土"],
    "sentence": "花儿长在土里。",
    "similar_chars": ["士", "王"],
    "ability": { "name": "筑墙", "effect": "bounce_floor" },
    "composites": []
  },
  {
    "char": "林", "pinyin": "lín", "radical": "木",
    "stroke_count": 8, "grade": 1, "epoch": 1, "world": "mountain",
    "char_type": "noun", "category": "nature",
    "words": ["山林", "森林", "林子"],
    "sentence": "山上有一片绿色的林子。",
    "similar_chars": [],
    "ability": null,
    "composites": ["森=林+木"]
  }
]
```

---

## 八、状态管理 (Zustand)

```typescript
// src/store/gameStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface GameState {
  // 玩家进度
  currentEpoch: number;
  unlockedWorlds: string[];
  completedLevels: Record<string, number[]>;  // worldId → [levelNumbers]
  collectedChars: string[];
  charStats: Record<string, CharStat>;        // 每个字的掌握情况

  // 当前关卡（临时状态）
  currentLevel: LevelConfig | null;
  combo: number;
  levelResult: LevelResult | null;

  // Actions
  startLevel: (config: LevelConfig) => void;
  completeLevel: (result: LevelResult) => void;
  addChar: (char: string) => void;
  updateCombo: (combo: number) => void;
}

export const useGameStore = create<GameState>()(
  persist(
    (set, get) => ({
      currentEpoch: 1,
      unlockedWorlds: ['mountain'],
      completedLevels: {},
      collectedChars: [],
      charStats: {},
      currentLevel: null,
      combo: 0,
      levelResult: null,

      startLevel: (config) => set({ currentLevel: config, combo: 0, levelResult: null }),

      completeLevel: (result) => {
        const state = get();
        const worldId = state.currentLevel?.world || '';
        const levelNum = state.currentLevel?.level || 0;

        const completed = { ...state.completedLevels };
        if (!completed[worldId]) completed[worldId] = [];
        if (!completed[worldId].includes(levelNum)) {
          completed[worldId].push(levelNum);
        }

        set({
          levelResult: result,
          completedLevels: completed,
          collectedChars: [...new Set([...state.collectedChars, ...result.newChars])],
        });
      },

      addChar: (char) => set((s) => ({
        collectedChars: [...new Set([...s.collectedChars, char])],
      })),

      updateCombo: (combo) => set({ combo }),
    }),
    { name: 'cangjiexuezi-save' } // localStorage 持久化
  )
);
```

---

## 九、AI 故事生成

```typescript
// src/services/ai.ts
const FALLBACK_STORIES = [
  '山上有木，木多成林，下起大雨，雨落成水。',
  '火在山上烧，水在山下流，土在中间，稳稳地守着。',
  '一棵木长在土里，又来一棵木，就变成了林。',
];

export async function generateStory(chars: string[]): Promise<string> {
  const apiKey = import.meta.env.VITE_OPENAI_API_KEY;

  if (!apiKey) {
    return FALLBACK_STORIES[Math.floor(Math.random() * FALLBACK_STORIES.length)];
  }

  try {
    const resp = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [{
          role: 'system',
          content: '你是一个给6岁小朋友讲故事的字灵。用最简单的话，把下面这些汉字串成一句有趣的话。不超过30个字，要押韵或有节奏感。只输出故事，不加解释。'
        }, {
          role: 'user',
          content: `请用这些字造一句话：${chars.join('、')}`
        }],
        max_tokens: 60,
        temperature: 0.9,
      }),
    });

    const data = await resp.json();
    return data.choices[0].message.content.trim();
  } catch {
    return FALLBACK_STORIES[Math.floor(Math.random() * FALLBACK_STORIES.length)];
  }
}
```

---

## 十、TTS 读音

```typescript
// src/services/tts.ts
export function speakChar(char: string, pinyin?: string) {
  if (!('speechSynthesis' in window)) return;

  const utterance = new SpeechSynthesisUtterance(char);
  utterance.lang = 'zh-CN';
  utterance.rate = 0.8;   // 稍慢，适合小孩
  utterance.pitch = 1.1;  // 稍高，更亲切

  window.speechSynthesis.speak(utterance);
}
```

---

## 十一、React 页面实现要点

### 11.1 路由结构

```typescript
// src/App.tsx
<Routes>
  <Route path="/" element={<HomePage />} />
  <Route path="/map" element={<WorldMap />} />
  <Route path="/play/:worldId/:level" element={<GamePage />} />
  <Route path="/result" element={<ResultScreen />} />
  <Route path="/collection" element={<CharCollection />} />
</Routes>
```

### 11.2 首页（HomePage）

```
┌────────────────────────────┐
│         bg-home.png         │
│                             │
│        ┌──────────┐        │
│        │   LOGO   │        │
│        │ 仓颉学字  │        │
│        └──────────┘        │
│                             │
│     ┌──────────────────┐   │
│     │    字灵打招呼      │   │
│     │  「又来接字啦！」   │   │
│     └──────────────────┘   │
│                             │
│     ┌──────────────────┐   │
│     │    ▶ 开始游戏      │   │
│     └──────────────────┘   │
│                             │
│     已收集 12/3500 字       │
│                             │
└────────────────────────────┘

技术：纯 React + CSS 动画
- Logo 入场：CSS @keyframes fadeInDown
- 字灵弹跳：CSS @keyframes bounce 循环
- 背景金色粒子：CSS 伪元素 + animation（不用 Phaser）
- 按钮悬停：scale(1.05) + box-shadow 加深
```

### 11.3 世界地图（WorldMap）

```
┌────────────────────────────┐
│       一纪·万物有形          │
│                             │
│   ●──●──●──●──●──●         │
│   山  天  田  家  村  ...    │
│   野  穹  园  园  落        │
│   ✓   🔒  🔒  🔒  🔒        │
│                             │
│   山野 - 已通关 3/6         │
│   ┌──┐ ┌──┐ ┌──┐           │
│   │✓ │ │✓ │ │✓ │ ○  ○  ★   │
│   └──┘ └──┘ └──┘           │
│    1    2    3   4  5   6   │
│                    当前 BOSS │
└────────────────────────────┘

技术：React + Framer Motion
- 关卡节点用 CSS circle + 条件样式
- 当前关卡呼吸动效：CSS animation pulse
- 解锁动画：Framer Motion layoutAnimation
- 路径连线：SVG <line> 或 CSS border
```

### 11.4 结算页（ResultScreen）

```
┌────────────────────────────┐
│       panel-result.png      │
│                             │
│      🌱 / 🌿 / 🌳           │
│      （种子/幼苗/大树）       │
│                             │
│    本关新字：                │
│    ┌────┐  ┌────┐          │
│    │ 火  │  │ 木  │          │
│    │huǒ │  │ mù │          │
│    └────┘  └────┘          │
│     点击听读音               │
│                             │
│    字灵说：                  │
│    「火在山上烧，            │
│      木在林中摇！」          │
│         （AI 生成）          │
│                             │
│    ┌──────────────────┐    │
│    │    ▶ 下一关        │    │
│    └──────────────────┘    │
│    ┌──────────────────┐    │
│    │    ◀ 回到地图      │    │
│    └──────────────────┘    │
└────────────────────────────┘

技术：React
- 字卡展示：CSS Grid / Flexbox
- 字卡点击 → speakChar(char) 播放读音
- AI 故事：useEffect 调 generateStory()，loading 时显示「字灵正在想...」
- 评价图标入场：CSS scale 动画从 0 → 1 + bounce
```

---

## 十二、关键依赖清单

```json
{
  "dependencies": {
    "react": "^18.3",
    "react-dom": "^18.3",
    "react-router-dom": "^6",
    "phaser": "^3.80",
    "zustand": "^4",
    "eventemitter3": "^5",
    "framer-motion": "^11"
  },
  "devDependencies": {
    "typescript": "^5",
    "vite": "^5",
    "@types/react": "^18",
    "tailwindcss": "^3",
    "autoprefixer": "^10",
    "postcss": "^8"
  }
}
```

---

## 十三、MVP 实现顺序 & 工时估算

| 序号 | 模块 | 预估工时 | 产出 | 依赖 |
|------|------|---------|------|------|
| 1 | 项目脚手架（Vite+React+Phaser+Tailwind） | 0.5h | 能跑的空项目 | 无 |
| 2 | BootScene 资源加载 | 0.5h | 所有素材可用 | 1 |
| 3 | GameScene 字下落 + Catcher 移动 | 1.5h | 字掉下来能接住 | 2 |
| 4 | 碰撞判定 + 目标/干扰分类 | 1h | 接对有反馈接错有反馈 | 3 |
| 5 | SpawnSystem + 关卡配置加载 | 1h | 从 JSON 读配置自动生成字 | 4 |
| 6 | 特效：接住飞入 + 粒子 + 碎裂 | 1.5h | 视觉体验到位 | 4 |
| 7 | ComboSystem + 3/5/10 特效 | 1h | combo 有感觉 | 6 |
| 8 | WeatherSystem（晴天+微风） | 0.5h | 字会飘 | 3 |
| 9 | LevelManager 过关判定 | 1h | 能过关能失败 | 5 |
| 10 | 首页（React） | 1h | 精美首页 | 1 |
| 11 | 世界地图（React） | 1.5h | 关卡选择 | 1 |
| 12 | 结算页（React） | 1h | 字卡+评价+AI故事 | 9 |
| 13 | 灰→彩色背景过渡 | 0.5h | 场景变化 | 3 |
| 14 | BOSS 拆字拼合 | 1.5h | 第 6 关能玩 | 4, 6 |
| 15 | AI 故事生成 + TTS | 1h | 过关有故事有读音 | 12 |
| 16 | Zustand 持久化 + 全流程串联 | 1h | 关卡进度保存 | 全部 |
| 17 | 部署 Vercel + 移动适配 | 0.5h | URL 可访问 | 全部 |
| | **总计** | **~16h** | | |

16 小时刚好覆盖两天的有效编码时间（Day1 8h + Day2 前半 8h，Day2 下午留给调试和演示准备）。
