import { Button } from "../components/Button";
import { BackgroundShell } from "../components/BackgroundShell";

interface HomeProps {
  learnedCount: number;
  onStart: () => void;
  onCollection: () => void;
  onSettings: () => void;
}

export function Home({ learnedCount, onStart, onCollection, onSettings }: HomeProps) {
  return (
    <BackgroundShell
      variant="home"
      title="仓颉学字"
      className="screen-shell--home-menu"
      contentClassName="screen-shell__content--home-menu"
      hideHeader
      hideFooter
    >
      <div className="home-menu">
        <div className="home-menu__sky">
          <div className="home-menu__moon" />
          <div className="home-menu__cloud home-menu__cloud--left" />
          <div className="home-menu__cloud home-menu__cloud--right" />
        </div>

        <section className="home-menu__title">
          <p className="home-menu__season">第一世界 · 山野修复</p>
          <h1>仓颉学字</h1>
          <p className="home-menu__tagline">举起手指，让文字归来</p>
        </section>

        <section className="home-menu__world-card">
          <div className="home-menu__world-ink">山 水 木 火 土 石</div>
          <div className="home-menu__world-copy">
            <strong>山野世界正在苏醒</strong>
            <span>已收集 {learnedCount}/6 个关键字</span>
          </div>
          <div className="home-menu__progress">
            <div className="home-menu__progress-fill" style={{ width: `${(learnedCount / 6) * 100}%` }} />
          </div>
        </section>

        <section className="home-menu__menu-panel">
          <Button className="home-menu__start" wide onClick={onStart}>
            开始修复
          </Button>
          <div className="home-menu__subactions">
            <Button variant="secondary" onClick={onCollection}>
              图鉴
            </Button>
            <Button variant="ghost" onClick={onSettings}>
              设置
            </Button>
          </div>
        </section>

        <div className="home-menu__hint">
          <span>触屏优先</span>
          <span>可切换摄像头模式</span>
        </div>
      </div>
    </BackgroundShell>
  );
}
