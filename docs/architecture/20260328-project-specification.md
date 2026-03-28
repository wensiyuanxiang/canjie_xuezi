# 仓颉学字（001_zaozi）项目规约

日期：2026-03-28  
目的：将《开发协作规约》与拟采用技术实现方式合并为单一执行标准，供程序、美术、音效与 AI 助手统一遵循。

---

## 1. 规约优先级与文档关系

出现冲突时解释顺序：

1. 本文档（`docs/architecture/20260328-project-specification.md`）
2. `docs/product/20260328-collaboration-contract.md`（协作基线，与本文档不一致时以本文档技术章节为准并回写协作文档）
3. `docs/product/20260328-hackathon-sprint-plan.md`
4. `docs/ux/20260328-asset-delivery-guide.md`
5. `docs/20260328-hanzi-planet-adventure-gdd.md`

职责划分：

- GDD：愿景与长期路线，不直接约束当前代码范围。
- 黑客松计划：MVP 范围与时间线。
- 素材手册：素材规格、命名、尺寸、交付优先级。
- 协作契约：并行开发边界与资源清单。
- 本文档：技术栈、工程结构、接口与质量基线。

---

## 2. 技术栈（与协作契约对齐）

| 层级 | 选型 | 说明 |
|------|------|------|
| 语言 | TypeScript | 严格模式；避免 `any`，必要时 `unknown` 收窄 |
| 应用壳 | React 18+ | 首页、世界地图、结算、外层状态 |
| 游戏运行时 | Phaser 3 | 关卡内下落字、接字区、碰撞、特效、BOSS 流程 |
| 构建 | Vite | 与契约中的 `src/App.tsx`、`src/main.tsx` 结构一致 |
| 样式 | CSS 模块或全局 CSS 变量 | 设计令牌见下文「视觉基线」 |
| 数据 | 本地 JSON | `src/data/*.json`，本轮无服务端持久化 |
| 部署 | Vercel | 产出可访问演示链接；环境变量不放密钥进仓库 |
| 读音 | Web Speech API | 不支持则静默降级 |
| 生成文案 | 单次 HTTP 调用 | 仅结算页短故事；失败用本地预设 |

未列入本轮：Next.js 全栈、服务端渲染为页面主路径、功能词系统、AI 动态难度闭环等（见协作契约「暂不进入」）。

---

## 3. 仓库与目录结构

采用协作契约规定的分层目录，实现时不得使用扁平 `images/` 堆文件。

```text
src/
├── assets/
│   ├── images/
│   │   ├── bg/
│   │   ├── character/
│   │   ├── game/
│   │   ├── particle/
│   │   ├── ui/
│   │   └── rank/
│   ├── audio/
│   │   ├── bgm/
│   │   └── sfx/
│   └── fonts/
├── components/          # React 通用与业务组件
├── game/
│   ├── scenes/          # Phaser Scene 类
│   ├── objects/         # Sprite / 游戏对象封装
│   └── systems/         # 与玩法相关的非 Scene 逻辑（如生成器）
├── data/                # characters.json、levels.json 等
├── services/            # AI 请求封装、本地存档、音频加载辅助等
├── styles/              # 全局样式与设计令牌
├── App.tsx
└── main.tsx
```

约定：

- 新建图片仅允许落在 `src/assets/images/` 的二级分类下。
- 音频仅在 `bgm/` 与 `sfx/`。
- 字体在 `src/assets/fonts/`。
- 占位资源路径集中配置（常量或小型 manifest），替换真实素材时不改业务分支逻辑。

---

## 4. React 与 Phaser 边界

| 侧 | 职责 |
|----|------|
| React | 首页、世界地图、结算页、路由或视图切换、全局 UI 状态（如是否通关解锁彩色背景） |
| Phaser | 关卡场景、下落与碰撞、游戏内特效、BOSS 流程 |

接口约定：

- React 通过 props、回调或轻量事件总线启动/销毁 Phaser 游戏挂载点（例如固定 `div` + `useRef`）。
- Phaser 结束关卡时只向 React 回传结构化结果（类型化的 plain object），不直接操作 React DOM。
- 不把完整应用 UI 写进 Phaser；避免 React 状态与 Phaser 内部对象双向强耦合。

推荐实现形态：

- `components/GameCanvas.tsx`（或同级）：负责创建/销毁 `Phaser.Game` 实例，订阅场景结束事件并 `onComplete(result)`。
- Phaser 侧通过 `scene.shutdown` 或自定义信号交出 `result`，字段与 `levels.json` 的 `winCondition` 解释一致即可。

---

## 5. 数据与类型

最小数据文件（与协作契约一致）：

- `src/data/characters.json`
- `src/data/levels.json`

`levels.json` 仅覆盖山野 MVP：`level-1` … `level-5`，`level-6-boss`。

每关最少字段：`id`、`type`、`title`、`targetChars`、`distractorChars`、`dropCount`、`fallSpeed`、`simultaneousCount`、`winCondition`、`backgroundKey`。

工程要求：

- 为上述 JSON 提供 TypeScript 类型（如 `types/level.ts`），加载时做运行时校验可选；MVP 可先做类型 + 开发期断言。
- 不为「三纪」等后续系统预埋复杂空 schema；扩展时演进版本号或并列新文件即可。

---

## 6. 资源命名与 P0 清单

命名规则（全小写、短横线、无空格、无中文文件名）以素材交付手册为准；协作契约中的废弃名不得在新增代码中引用。

P0 资源缺失时：程序必须可运行（占位图、静音、本地文案），不阻塞主流程联调。

P0 文件名与路径以 `docs/product/20260328-collaboration-contract.md` 第五节为权威列表；实现时建议维护 `ASSET_KEYS` 常量与占位映射表，避免字符串散落。

---

## 7. 视觉与交互基线

CSS 变量（可在 `styles/` 或 `:root` 统一声明）：

```css
--color-bg: #F5F0E8;
--color-primary: #FF9F43;
--color-secondary: #6C8EBF;
--color-accent: #FFD93D;
--color-text: #2D3436;
--color-text-light: #636E72;
--color-success: #6BCB77;
--color-panel: #FFFFFF;
```

原则：字大、背景弱、目标字偏暖、干扰字偏冷；字灵不挡接字区；**手机竖屏优先**，PC 兼容。

---

## 8. AI、音频与降级

- 结算页：单次 API 调用生成短故事；失败回退本地预设数组随机或轮播。
- 禁止开放聊天、禁止把模型输出当作识字或读音事实源。
- 音效缺失：静音路径仍走同一触发点，避免分支爆炸。
- BOSS 仅在其他流程稳定后再允许削减范围（协作契约约定）。

---

## 9. 质量与工程习惯

与组织级规范对齐（不重复全文，执行时遵守）：

- Conventional Commits；小步提交，素材重命名与玩法逻辑不混在同一提交。
- 日志与错误信息脱敏；API Key 仅环境变量。
- 测试：项目脚手架落地后补齐 Vitest（纯逻辑与数据解析）与关键路径 E2E（可选 Playwright）；覆盖率目标与仓库 CI 策略后续在 `package.json` 与 CI 中固化。

分支建议（与协作契约一致）：`main` 可运行；功能用 `feat/app-shell`、`feat/gameplay-core`、`feat/ui-pages`、`feat/assets-drop-1` 等。

---

## 10. MVP 交付核对（程序视角）

本轮程序侧应能支撑：

- 首页、世界地图、山野 6 节点（5 普通 + 1 BOSS）、基础 combo 反馈、字灵表情切换、结算页、通关后灰白背景切彩色、基础音效与 1 首山野 BGM、Vercel 可访问链接。

每日联调检查项以协作契约第十三节为准；时间不足时优先级：可玩、可通关、可部署、再美化。

---

## 11. 角色边界（重申）

- **程序（A）**：React 结构、Phaser 逻辑、数据与关卡配置、资源加载、本地存档、AI 封装、部署与适配。
- **素材（B）**：图、UI 稿、音效、BGM、字体；不改程序逻辑文件。
- 素材命名与规约不一致时，由素材侧改名，代码侧不增加长期兼容分支。

---

## 12. 修订方式

新增或变更约定时：先更新本文档，再按需同步 `20260328-collaboration-contract.md`，避免口头约定漂移。

辅助工具与副本：

- 仓库根目录 `AGENTS.md`：供 **Codex** 等读取 `AGENTS.md` 的代理使用，为本规约的操作摘要。
- `.cursor/rules/project-spec.mdc`：Cursor 始终加载的摘要规则。
- 三者（本文档、`AGENTS.md`、`.cursor/rules/project-spec.mdc`）应保持一致；以本文档为权威来源。
