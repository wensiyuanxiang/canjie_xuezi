# 仓颉学字 - 开发协作规约

日期：2026-03-28
目的：统一现有文档中的冲突项，作为程序、美术、音效并行开发时的唯一协作基线。

---

## 一、规约优先级

出现冲突时，按以下顺序解释：

1. 本文档
2. 黑客松冲刺计划
3. 素材交付手册
4. GDD

各文档职责如下：

- GDD：定义产品愿景、玩法原则、长期路线，不直接作为当前代码实现范围。
- 黑客松冲刺计划：定义本次 MVP 范围、时间线、角色分工。
- 素材交付手册：定义素材规格、命名、尺寸、交付优先级。
- 本文档：解决以上文档之间的冲突，给出当前仓库的唯一执行标准。

---

## 二、本次 MVP 范围

本次只做黑客松 MVP，不做 GDD 全量内容。

必须交付：

- 首页
- 世界地图
- 山野世界 6 个关卡节点
- 5 个普通关
- 1 个 BOSS 关
- 基础 combo 反馈
- 字灵表情切换
- 结算页
- 通关后灰白背景切换为彩色背景
- 基础音效和 1 首山野 BGM
- Vercel 可访问演示链接

暂不进入本轮实现：

- 八大世界全量内容
- 三纪完整进程
- 天书残页关
- AI 动态难度闭环
- 功能词系统
- 大规模字库
- 金色彩蛋字
- 完整能力体系

说明：

- GDD 中的系统设计保留为后续扩展方向。
- 当前代码只需要为后续扩展留接口，不需要一次实现完。

---

## 三、目录规范

仓库采用分层目录，不使用扁平资产目录。

标准结构如下：

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
├── components/
├── game/
│   ├── scenes/
│   ├── objects/
│   └── systems/
├── data/
├── services/
├── styles/
├── App.tsx
└── main.tsx
```

执行规则：

- 图片全部放入 `src/assets/images/` 下的二级分类目录。
- 音频全部放入 `src/assets/audio/bgm/` 或 `src/assets/audio/sfx/`。
- 字体全部放入 `src/assets/fonts/`。
- 不允许把新素材直接堆在 `images/` 根目录。

---

## 四、文件命名规范

文件命名以素材交付手册为准，统一使用：

- 全小写
- 短横线分隔
- 不带空格
- 不使用中文文件名

示例：

- `bg-mountain-gray.png`
- `zilin-neutral.png`
- `char-bg-target.png`
- `sfx-catch-correct.mp3`
- `NotoSansSC-Bold.otf`

以下旧命名全部废弃，不再作为代码依赖：

- `zilin.png`
- `btn-start.png`
- `btn-next.png`
- `sfx-catch.mp3`
- `sfx-wrong.mp3`

如果历史代码中已经引用旧命名，必须在合并前统一替换。

---

## 五、资源清单基线

程序默认依赖以下 P0 资源，不等待 P1/P2 才开工：

图片：

- `bg/bg-home.png`
- `bg/bg-mountain-gray.png`
- `bg/bg-mountain-color.png`
- `character/zilin-neutral.png`
- `character/zilin-happy.png`
- `character/zilin-sad.png`
- `character/catcher.png` 或 `character/catcher-tray.png`
- `game/char-bg-target.png`
- `game/char-bg-distractor.png`
- `particle/particle-star.png`
- `particle/particle-glow.png`
- `ui/logo.png`
- `ui/btn-primary.png`
- `ui/panel-result.png`
- `ui/panel-charcard.png`
- `ui/icon-level-current.png`
- `ui/icon-level-done.png`
- `rank/rank-seed.png`
- `rank/rank-sprout.png`
- `rank/rank-tree.png`

音频：

- `bgm/bgm-home.mp3`
- `bgm/bgm-mountain.mp3`
- `sfx/sfx-catch-correct.mp3`
- `sfx/sfx-catch-wrong.mp3`
- `sfx/sfx-combo-3.mp3`
- `sfx/sfx-level-clear.mp3`
- `sfx/sfx-btn-click.mp3`

字体：

- `NotoSansSC-Bold.otf`

程序约定：

- P0 资源缺失时，程序必须允许用占位资源继续开发。
- 不因单个素材未到位阻塞主流程联调。

---

## 六、代码职责边界

A 负责：

- React 页面结构
- Phaser 游戏逻辑
- 数据结构和关卡配置
- 资源加载代码
- 本地存档
- AI 接口封装
- 部署与适配

B 负责：

- 图片素材
- UI 视觉稿
- 音效
- BGM
- 字体落地

边界规则：

- B 不改程序逻辑文件。
- A 不改素材文件名来迁就临时导出结果。
- 如素材文件名和规约不一致，由素材侧改名，不由代码侧加兼容分支。

---

## 七、页面与场景边界

React 负责：

- 首页
- 世界地图
- 结算页
- 外层状态管理

Phaser 负责：

- 游戏内关卡
- 下落字
- 接收区移动
- 碰撞检测
- 游戏特效
- BOSS 关流程

接口约定：

- React 通过 props 或事件启动 Phaser 场景。
- Phaser 结束后只返回关卡结果数据，不直接操作 React 页面 DOM。
- UI 页面不写进 Phaser 内部，避免状态耦合。

---

## 八、数据规范

本轮仅使用本地 JSON。

建议最小数据文件：

- `src/data/characters.json`
- `src/data/levels.json`

`levels.json` 只覆盖山野 MVP 关卡：

- `level-1` 到 `level-5`：普通关
- `level-6-boss`：BOSS 关

每关最少包含：

- `id`
- `type`
- `title`
- `targetChars`
- `distractorChars`
- `dropCount`
- `fallSpeed`
- `simultaneousCount`
- `winCondition`
- `backgroundKey`

约束：

- 不提前为三纪全量系统设计过重 schema。
- 当前 schema 只服务 MVP，可扩展但不预埋复杂空字段。

---

## 九、视觉与交互基线

统一配色变量：

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

统一设计原则：

- 字必须大，优先保证辨认性。
- 背景必须安静，不抢字。
- 目标字使用暖色，干扰字使用冷色。
- 字灵常驻角落，但不遮挡接字区域。
- 手机竖屏优先，PC 仅做兼容。

---

## 十、AI 与语音边界

本轮 AI 只做结算页一句短故事。

实现约定：

- 只发起一次简单接口调用。
- 调用失败时回退到本地预设文案。
- 不做开放聊天。
- 不把模型生成结果直接当作读音或字词事实来源。

TTS 约定：

- 汉字读音优先用 Web Speech API。
- 如果浏览器不支持，允许静默降级，不阻塞主流程。

---

## 十一、占位与降级策略

任何人都不能因为等待另一侧交付而停工。

统一降级方式：

- 缺图片：用纯色块或 CSS 渐变占位
- 缺音效：静音占位
- 缺 AI：本地随机文案
- 缺 BOSS：最后才允许砍，前提是先保住 5 个普通关全流程

程序要求：

- 占位资源路径集中管理，后续替换不改业务逻辑。

---

## 十二、Git 与提交流程

分支建议：

- `main`：始终保持可运行
- `feat/app-shell`
- `feat/gameplay-core`
- `feat/ui-pages`
- `feat/assets-drop-1`

提交规则：

- 小步提交
- 每次提交只做一类事情
- 不混合“重命名素材”和“改玩法逻辑”

提交信息建议：

- `feat: scaffold react + phaser app shell`
- `feat: add mountain world level config`
- `feat: wire result screen with ai fallback`
- `chore: add p0 image placeholders`

禁止事项：

- 不直接把实验代码堆到 `main`
- 不在未同步命名规范前写死临时资源路径
- 不用本地未提交文件作为“默认存在”的依赖

---

## 十三、联调检查清单

每天至少做一次全流程联调，检查以下内容：

- 首页可进入地图
- 地图可进入关卡
- 普通关可完成
- BOSS 关可完成
- 结算页可显示
- 背景可从灰切彩
- 音效可播放
- 返回流程不断链
- 手机竖屏布局不炸

若当天时间不足，优先级如下：

1. 可玩
2. 可通关
3. 可部署
4. 再美化

---

## 十四、当前统一决议

本项目从现在开始按以下决议执行：

- 目录结构采用素材交付手册的分层目录。
- 文件命名采用素材交付手册的正式命名。
- 功能范围采用黑客松冲刺计划的 MVP 范围。
- 玩法原则与后续扩展采用 GDD。
- 程序对缺失素材必须可降级运行。
- 所有新代码默认面向手机竖屏。

---

## 十五、后续动作

建议下一步按以下顺序推进：

1. 先搭项目骨架和目录
2. 再写 `levels.json` 与 `characters.json`
3. 同时接入占位素材路径
4. 先跑通首页 → 地图 → 关卡 → 结算
5. 最后替换真实素材和补 AI

这份规约生效后，如有新决定，直接改本文档，不在聊天里口头漂移。
