import { BackgroundShell } from "../components/BackgroundShell";
import { Button } from "../components/Button";
import { Panel } from "../components/Panel";
import type { AppSettings } from "../types/game";

interface SettingsProps {
  settings: AppSettings;
  onBack: () => void;
  onOpenCalibration: () => void;
  onUpdate: (partial: Partial<AppSettings>) => void;
}

export function Settings({ settings, onBack, onOpenCalibration, onUpdate }: SettingsProps) {
  return (
    <BackgroundShell
      variant="settings"
      badge="卷轴设置"
      title="修复工具"
      subtitle="让摄像头、音频和操作手感都保持在适合孩子的状态。"
      footer={<Button variant="ghost" onClick={onBack}>返回</Button>}
    >
      <div className="settings-grid">
        <Panel title="输入方式">
          <div className="toggle-row">
            <span>当前模式</span>
            <div className="choice-chips">
              <button
                className={settings.inputMode === "touch" ? "choice-chip choice-chip--active" : "choice-chip"}
                onClick={() => onUpdate({ inputMode: "touch" })}
                type="button"
              >
                触屏 / 鼠标
              </button>
              <button
                className={settings.inputMode === "camera" ? "choice-chip choice-chip--active" : "choice-chip"}
                onClick={() => onUpdate({ inputMode: "camera" })}
                type="button"
              >
                前置摄像头
              </button>
            </div>
          </div>
          <div className="toggle-row">
            <span>左右手模式</span>
            <label className="switch">
              <input
                checked={settings.leftHandMode}
                onChange={(event) => onUpdate({ leftHandMode: event.target.checked })}
                type="checkbox"
              />
              <span>镜像映射</span>
            </label>
          </div>
          <div className="toggle-row">
            <span>识别灵敏度</span>
            <input
              max={0.85}
              min={0.2}
              onChange={(event) => onUpdate({ sensitivity: Number(event.target.value) })}
              step={0.05}
              type="range"
              value={settings.sensitivity}
            />
          </div>
          <Button variant="secondary" onClick={onOpenCalibration}>
            重新校准摄像头
          </Button>
        </Panel>

        <Panel title="音频与性能">
          <div className="toggle-row">
            <span>背景音乐</span>
            <label className="switch">
              <input
                checked={settings.musicEnabled}
                onChange={(event) => onUpdate({ musicEnabled: event.target.checked })}
                type="checkbox"
              />
              <span>{settings.musicEnabled ? "开启" : "关闭"}</span>
            </label>
          </div>
          <div className="toggle-row">
            <span>音效</span>
            <label className="switch">
              <input
                checked={settings.sfxEnabled}
                onChange={(event) => onUpdate({ sfxEnabled: event.target.checked })}
                type="checkbox"
              />
              <span>{settings.sfxEnabled ? "开启" : "关闭"}</span>
            </label>
          </div>
          <div className="toggle-row">
            <span>摄像头预览小窗</span>
            <label className="switch">
              <input
                checked={settings.showCameraPreview}
                onChange={(event) => onUpdate({ showCameraPreview: event.target.checked })}
                type="checkbox"
              />
              <span>{settings.showCameraPreview ? "显示" : "隐藏"}</span>
            </label>
          </div>
          <div className="toggle-row">
            <span>低性能模式</span>
            <label className="switch">
              <input
                checked={settings.lowPerformanceMode}
                onChange={(event) => onUpdate({ lowPerformanceMode: event.target.checked })}
                type="checkbox"
              />
              <span>{settings.lowPerformanceMode ? "简化特效" : "完整特效"}</span>
            </label>
          </div>
          <div className="toggle-row">
            <span>辅助高亮</span>
            <label className="switch">
              <input
                checked={settings.assistHighlight}
                onChange={(event) => onUpdate({ assistHighlight: event.target.checked })}
                type="checkbox"
              />
              <span>{settings.assistHighlight ? "开启" : "关闭"}</span>
            </label>
          </div>
        </Panel>
      </div>
    </BackgroundShell>
  );
}
