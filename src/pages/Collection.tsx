import { BackgroundShell } from "../components/BackgroundShell";
import { Button } from "../components/Button";
import { Panel } from "../components/Panel";
import type { CharacterEntry } from "../types/game";

interface CollectionProps {
  characters: CharacterEntry[];
  learnedChars: string[];
  onBack: () => void;
}

export function Collection({ characters, learnedChars, onBack }: CollectionProps) {
  const learnedSet = new Set(learnedChars);
  const collectible = characters.filter((entry) => entry.theme !== "干扰");

  return (
    <BackgroundShell
      variant="collection"
      badge="字灵图鉴"
      title="山野收集册"
      subtitle="图鉴像一册被重新点亮的字书，记录你已经唤回的每一个字。"
      footer={<Button variant="ghost" onClick={onBack}>返回地图</Button>}
    >
      <Panel title="当前完成度" extra={<strong>{learnedChars.length}/{collectible.length}</strong>}>
        <div className="collection-grid">
          {collectible.map((entry) => {
            const learned = learnedSet.has(entry.char);
            return (
              <article
                key={entry.id}
                className={learned ? "char-card char-card--learned" : "char-card"}
              >
                <header>
                  <span>{learned ? "已归位" : "待修复"}</span>
                  <strong>{entry.theme}</strong>
                </header>
                <div className="char-card__glyph">{entry.char}</div>
                <p>{entry.hint}</p>
                <small>{entry.words.join(" · ")}</small>
              </article>
            );
          })}
        </div>
      </Panel>
    </BackgroundShell>
  );
}
