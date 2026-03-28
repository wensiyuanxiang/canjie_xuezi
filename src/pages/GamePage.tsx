import { useEffect, useMemo, useRef, useState } from "react";

import { BackgroundShell } from "../components/BackgroundShell";
import { Button } from "../components/Button";
import { Panel } from "../components/Panel";
import { GameCanvas } from "../game/GameCanvas";
import {
  createHandTrackerController,
  type HandPoint,
} from "../lib/handTracking/handTracking";
import type { AppSettings, GameResult, LevelConfig } from "../types/game";

interface GamePageProps {
  level: LevelConfig;
  settings: AppSettings;
  onBack: () => void;
  onComplete: (result: GameResult) => void;
}

export function GamePage({ level, settings, onBack, onComplete }: GamePageProps) {
  const controller = useMemo(() => createHandTrackerController(), []);
  const previewRef = useRef<HTMLVideoElement | null>(null);
  const [handPoint, setHandPoint] = useState<HandPoint | null>(null);
  const [cameraError, setCameraError] = useState<string | null>(null);

  useEffect(() => {
    if (settings.inputMode !== "camera" || !previewRef.current) {
      controller.stop();
      setHandPoint(null);
      return;
    }

    let active = true;

    const start = async () => {
      try {
        await controller.start(previewRef.current!, (point) => {
          if (active) {
            setHandPoint(point);
          }
        });
        setCameraError(null);
      } catch (error) {
        const message =
          error instanceof Error ? error.message : "摄像头不可用，已建议切回触屏模式。";
        setCameraError(message);
      }
    };

    void start();

    return () => {
      active = false;
      controller.stop();
    };
  }, [controller, settings.inputMode]);

  const showPreview = settings.inputMode === "camera" && settings.showCameraPreview;

  return (
    <BackgroundShell
      variant={level.mode === "boss" ? "bossMountain" : "mountainGray"}
      badge={`第 ${level.level} 关`}
      title={level.title}
      subtitle={level.objectiveText}
      headerActions={<Button variant="ghost" onClick={onBack}>返回地图</Button>}
    >
      <div className="game-layout">
        <div className="game-stage-shell">
          <GameCanvas handPoint={handPoint} level={level} onComplete={onComplete} settings={settings} />
          <video className={showPreview ? "game-preview" : "game-preview game-preview--hidden"} ref={previewRef} />
        </div>

        <div className="game-sidebar">
          <Panel title="本关目标">
            <p>{level.objectiveText}</p>
            <div className="tag-row">
              {level.newChars.map((char) => (
                <span className="ink-tag" key={char}>
                  新字 · {char}
                </span>
              ))}
            </div>
          </Panel>

          <Panel title="输入状态">
            <p>{settings.inputMode === "camera" ? "当前使用摄像头食指映射。" : "当前使用触屏 / 鼠标划切。"}</p>
            {settings.inputMode === "camera" ? (
              <p>{cameraError ?? (handPoint ? "已检测到指尖，正在同步笔锋。" : "正在寻找食指位置。")}</p>
            ) : (
              <p>如果现场识别不稳，可以保持这个模式完成演示。</p>
            )}
          </Panel>
        </div>
      </div>
    </BackgroundShell>
  );
}
