import { BackgroundShell } from "../components/BackgroundShell";
import { Button } from "../components/Button";
import { Panel } from "../components/Panel";
import { getLevelAccuracy, getSummaryTier } from "../lib/progression/worldProgress";
import type { CharacterEntry, GameResult, LevelConfig } from "../types/game";

interface ResultProps {
  result: GameResult;
  level: LevelConfig;
  characters: CharacterEntry[];
  onNext: () => void;
  onReplay: () => void;
  onBackToMap: () => void;
}

const tierLabel = {
  seed: "种子",
  sprout: "幼苗",
  tree: "大树",
} as const;

export function Result({
  result,
  level,
  characters,
  onNext,
  onReplay,
  onBackToMap,
}: ResultProps) {
  const accuracy = getLevelAccuracy(result);
  const tier = getSummaryTier(result);
  const learnedCards = characters.filter((entry) => result.learnedChars.includes(entry.char));

  const speak = (text: string) => {
    if (typeof window === "undefined" || !("speechSynthesis" in window)) {
      return;
    }

    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = "zh-CN";
    window.speechSynthesis.cancel();
    window.speechSynthesis.speak(utterance);
  };

  return (
    <BackgroundShell
      variant="result"
      badge="关卡结算"
      title={result.cleared ? `你拿到了${tierLabel[tier]}` : "这关还差一点"}
      subtitle={result.cleared ? result.repairPreview : "再切准一些，山野就会继续亮起来。"}
      footer={<Button variant="ghost" onClick={onBackToMap}>返回地图</Button>}
    >
      <div className="result-grid">
        <Panel title="本关总结" extra={<strong>{level.title}</strong>}>
          <div className="result-stats">
            <div className="result-stat">
              <span>命中率</span>
              <strong>{accuracy}%</strong>
            </div>
            <div className="result-stat">
              <span>最高连切</span>
              <strong>{result.maxCombo}</strong>
            </div>
            <div className="result-stat">
              <span>切对 / 切错</span>
              <strong>
                {result.targetHits} / {result.wrongHits}
              </strong>
            </div>
          </div>
        </Panel>

        <Panel title="新学字卡">
          {learnedCards.length > 0 ? (
            <div className="collection-grid">
              {learnedCards.map((entry) => (
                <article className="char-card char-card--learned" key={entry.id}>
                  <header>
                    <span>{entry.pinyin}</span>
                    <strong>{entry.theme}</strong>
                  </header>
                  <div className="char-card__glyph">{entry.char}</div>
                  <p>{entry.hint}</p>
                  <div className="result-card__actions">
                    <Button variant="secondary" onClick={() => speak(`${entry.char}，${entry.words[0]}`)}>
                      朗读字卡
                    </Button>
                  </div>
                </article>
              ))}
            </div>
          ) : (
            <p>这一关主要是复习和熟悉手感，没有新增字卡入库。</p>
          )}
        </Panel>

        <Panel title="下一步">
          <p>{result.repairPreview}</p>
          <div className="hero-copy__actions">
            <Button onClick={onNext}>下一关</Button>
            <Button variant="secondary" onClick={onReplay}>
              再试一次
            </Button>
          </div>
        </Panel>
      </div>
    </BackgroundShell>
  );
}
