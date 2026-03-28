import { useEffect, useMemo, useRef, useState } from "react";

import { BackgroundShell } from "../components/BackgroundShell";
import { Button } from "../components/Button";
import { Panel } from "../components/Panel";
import {
  createHandTrackerController,
  type HandPoint,
} from "../lib/handTracking/handTracking";
import type { CalibrationProfile } from "../types/game";

interface CalibrationProps {
  onBack: () => void;
  onComplete: (profile: CalibrationProfile) => void;
}

export function Calibration({ onBack, onComplete }: CalibrationProps) {
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const controller = useMemo(() => createHandTrackerController(), []);
  const [point, setPoint] = useState<HandPoint | null>(null);
  const [status, setStatus] = useState("举起一根食指，靠近镜头中央。");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    const start = async () => {
      if (!videoRef.current) {
        return;
      }

      try {
        await controller.start(videoRef.current, (nextPoint) => {
          if (!mounted) {
            return;
          }

          setPoint(nextPoint);
          setStatus(nextPoint ? "识别成功，试着把指尖移动到圆框中心。" : "正在继续寻找你的食指。");
        });
      } catch (startError) {
        const message =
          startError instanceof Error ? startError.message : "摄像头暂时不可用，请切回触屏模式。";
        setError(message);
      }
    };

    void start();

    return () => {
      mounted = false;
      controller.stop();
    };
  }, [controller]);

  const confirmDisabled = !point;

  return (
    <BackgroundShell
      variant="calibration"
      badge="校准手指"
      title="让笔锋和食指对上"
      subtitle="识别成功后，游戏里会把你的指尖映射成金色笔锋。"
      footer={<Button variant="ghost" onClick={onBack}>返回</Button>}
    >
      <div className="calibration-layout">
        <Panel title="前置镜头">
          <div className="calibration-stage">
            <video className="camera-preview" ref={videoRef} />
            <div className="calibration-target" />
            {point ? (
              <div
                className="calibration-pointer"
                style={{
                  left: `${point.normalizedX * 100}%`,
                  top: `${point.normalizedY * 100}%`,
                }}
              />
            ) : null}
          </div>
        </Panel>

        <Panel title="校准提示">
          <p>{error ?? status}</p>
          <div className="calibration-actions">
            <Button
              disabled={confirmDisabled}
              onClick={() =>
                onComplete({
                  ready: Boolean(point),
                  normalizedX: point?.normalizedX ?? 0.5,
                  normalizedY: point?.normalizedY ?? 0.5,
                })
              }
            >
              完成校准
            </Button>
            <Button variant="secondary" onClick={onBack}>
              先用触屏模式
            </Button>
          </div>
        </Panel>
      </div>
    </BackgroundShell>
  );
}
