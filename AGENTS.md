# 仓颉学字（001_zaozi）— Codex / Agent 规约

本文件供 OpenAI Codex 及读取 `AGENTS.md` 的代理使用。**完整条文**以架构文档为准；此处为可执行的摘要与协作指令。

## 权威文档与优先级

1. `docs/architecture/20260328-project-specification.md`（技术与工程完整规约）
2. `docs/product/20260328-collaboration-contract.md`
3. `docs/product/20260328-hackathon-sprint-plan.md`
4. `docs/ux/20260328-asset-delivery-guide.md`
5. `docs/20260328-hanzi-planet-adventure-gdd.md`

实现范围以**黑客松 MVP** 为界；GDD 全量不进入本轮代码（仅保留扩展空间）。

## 技术栈

- **Vite** + **React 18** + **TypeScript**（`strict`）+ **Phaser 3**
- 数据：`src/data/characters.json`、`src/data/levels.json`（山野 `level-1`～`level-5`、`level-6-boss`）
- 部署：**Vercel**；密钥仅环境变量，不入库、不入日志

## 目录与资源（强制）

- 图片：`src/assets/images/{bg,character,game,particle,ui,rank}/`（禁止向 `images/` 根目录堆新文件）
- 音频：`src/assets/audio/bgm/`、`sfx/`
- 字体：`src/assets/fonts/`
- 命名：全小写、kebab-case、无空格、无中文文件名；禁止协作契约中已声明**废弃**的旧文件名
- P0 缺失时：**占位 + 可运行**；占位路径集中配置（常量或 manifest），替换素材不改业务分支

目录树与模块职责见架构文档第 3、4、5 节。

## React 与 Phaser

- **React**：首页、世界地图、结算、外层状态（含灰/彩背景等）
- **Phaser**：关卡内玩法、碰撞、特效、BOSS；结束时只向 React **回传结构化结果**，不操作 React DOM
- 不把主 UI 写进 Phaser；推荐 `GameCanvas` 类组件负责 `Phaser.Game` 生命周期与 `onComplete(result)`

## 视觉与产品约束

- 使用架构文档中的 CSS 设计变量；**手机竖屏优先**
- 结算页 **AI**：单次 HTTP 调用 + 本地文案回退；无聊天；不把模型输出当识字/读音事实
- **TTS**：Web Speech API，不支持则静默降级

## Git 与提交

- **Conventional Commits**（`feat:`、`fix:`、`chore:` 等）
- 小步提交；**不要**在同一提交里混「素材重命名」与「玩法逻辑变更」

## 安全与质量

- 日志脱敏；禁止打印 API Key、Token、JWT
- 脚手架就绪后：用 Vitest 覆盖纯逻辑与 JSON 解析；关键路径可上 Playwright（目标与 CI 以 `package.json` 为准）

## Codex 工作方式（建议）

- 改代码前先阅读相关现有文件与 `docs/architecture/20260328-project-specification.md` 对应章节
- 改动保持最小、与当前代码风格一致；不做无关重构
- 若约定变更：先改 `docs/architecture/20260328-project-specification.md`，再同步本文件与 `.cursor/rules/project-spec.mdc`
