import { BackgroundShell } from "../components/BackgroundShell";
import { Button } from "../components/Button";
import { Panel } from "../components/Panel";
import type { CompletedLevelRecord, LevelConfig } from "../types/game";

interface WorldMapProps {
  levels: LevelConfig[];
  unlockedLevels: string[];
  completedLevels: CompletedLevelRecord[];
  learnedCount: number;
  totalLearnable: number;
  repairPercent: number;
  currentLevelId: string;
  onBack: () => void;
  onCollection: () => void;
  onSettings: () => void;
  onPlayLevel: (levelId: string) => void;
}

export function WorldMap({
  levels,
  unlockedLevels,
  completedLevels,
  learnedCount,
  totalLearnable,
  repairPercent,
  currentLevelId,
  onBack,
  onCollection,
  onSettings,
  onPlayLevel,
}: WorldMapProps) {
  const completedSet = new Set(completedLevels.filter((entry) => entry.cleared).map((entry) => entry.levelId));

  return (
    <BackgroundShell
      variant="worldMap"
      badge="第一世界 · 山野"
      title="山野卷轴"
      subtitle="云雾正在散开，沿着金色路径一步步点亮山河。"
      headerActions={<Button variant="ghost" onClick={onSettings}>设置</Button>}
      footer={<Button variant="ghost" onClick={onBack}>返回首页</Button>}
    >
      <div className="map-layout">
        <Panel title="修复进度" extra={<strong>{repairPercent}%</strong>}>
          <div className="progress-track">
            <div className="progress-track__fill" style={{ width: `${repairPercent}%` }} />
          </div>
          <div className="stat-row">
            <span>已学字数</span>
            <strong>
              {learnedCount}/{totalLearnable}
            </strong>
          </div>
        </Panel>

        <div className="map-path">
          {levels.map((level) => {
            const unlocked = unlockedLevels.includes(level.id);
            const cleared = completedSet.has(level.id);
            const active = level.id === currentLevelId;
            return (
              <button
                key={level.id}
                className={[
                  "map-node",
                  unlocked ? "map-node--unlocked" : "map-node--locked",
                  cleared ? "map-node--cleared" : "",
                  active ? "map-node--active" : "",
                ]
                  .filter(Boolean)
                  .join(" ")}
                disabled={!unlocked}
                onClick={() => onPlayLevel(level.id)}
                type="button"
              >
                <span className="map-node__seal">{level.mode === "boss" ? "封" : level.level}</span>
                <strong>{level.title}</strong>
                <small>{level.newChars.join(" / ") || "复习"}</small>
              </button>
            );
          })}
        </div>

        <Panel title="山野修复日志">
          <p>从山、水、木、火、土、石一路推进，最终解封中央的“林”。</p>
          <Button variant="secondary" onClick={onCollection}>
            打开图鉴
          </Button>
        </Panel>
      </div>
    </BackgroundShell>
  );
}
