import { useEffect, useMemo, useRef } from "react";
import Phaser from "phaser";

import { audioManager } from "../lib/audio/audioManager";
import type { HandPoint } from "../lib/handTracking/handTracking";
import type { AppSettings, GameResult, LevelConfig } from "../types/game";
import { MountainLevelScene } from "./scenes/MountainLevelScene";

interface GameCanvasProps {
  level: LevelConfig;
  settings: AppSettings;
  handPoint: HandPoint | null;
  onComplete: (result: GameResult) => void;
}

export function GameCanvas({
  level,
  settings,
  handPoint,
  onComplete,
}: GameCanvasProps) {
  const hostRef = useRef<HTMLDivElement | null>(null);
  const handPointRef = useRef<HandPoint | null>(handPoint);

  handPointRef.current = handPoint;

  const callbacks = useMemo(
    () => ({
      onSlashCorrect: () => audioManager.playSfx("slashCorrect", settings.sfxEnabled),
      onSlashWrong: () => audioManager.playSfx("slashWrong", settings.sfxEnabled),
      onComboUp: () => audioManager.playSfx("comboUp", settings.sfxEnabled),
      onBossComplete: () => audioManager.playSfx("bossComplete", settings.sfxEnabled),
    }),
    [settings.sfxEnabled],
  );

  useEffect(() => {
    if (!hostRef.current) {
      return;
    }

    const scene = new MountainLevelScene({
      level,
      settings,
      getHandPoint: () => handPointRef.current,
      onComplete,
      ...callbacks,
    });

    const game = new Phaser.Game({
      type: Phaser.AUTO,
      width: 390,
      height: 844,
      parent: hostRef.current,
      transparent: true,
      scene,
      scale: {
        mode: Phaser.Scale.FIT,
        autoCenter: Phaser.Scale.CENTER_BOTH,
      },
      physics: {
        default: "arcade",
      },
    });

    return () => {
      game.destroy(true);
    };
  }, [callbacks, level, onComplete, settings]);

  return <div className="game-canvas" ref={hostRef} />;
}
