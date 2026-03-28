# 仓颉学字 - 黑客松 2 天冲刺计划

日期：2026-03-28
目的：两人分工、资产交接规范、时间线安排。

---

## 角色分工

| | A：程序（你） | B：美术 + 音效（朋友） |
|---|---|---|
| 工具 | VS Code / Cursor, Git | Figma / Procreate / AI 绘图工具, 音效工具 |
| 产出 | 代码、关卡 JSON、AI 接口对接 | PNG/SVG 素材、音效文件、字体 |
| 交接方式 | Git 仓库 `src/assets/` 目录 | 按约定命名直接放入 assets 目录 |

---

## 技术栈确认

```
框架：      React 18 + TypeScript
游戏引擎：  Phaser 3（嵌入 React 页面）
构建工具：  Vite
AI 故事：   fetch 调 OpenAI API（一次调用）
TTS：      Web Speech API（浏览器内置）
数据：      本地 JSON（字库 + 关卡配置）
部署：      Vercel（推代码自动上线，答辩给 URL）
后端：      不需要（MVP 阶段全部前端完成）
```

---

## 项目结构

```
src/
├── assets/
│   ├── images/
│   │   ├── bg-mountain-gray.png      # 山野背景（灰白版）
│   │   ├── bg-mountain-color.png     # 山野背景（彩色版）
│   │   ├── zilin.png                 # 字灵角色
│   │   ├── zilin-happy.png           # 字灵表情：开心
│   │   ├── zilin-sad.png             # 字灵表情：惋惜
│   │   ├── catcher.png               # 接收区/角色
│   │   ├── particle-star.png         # 粒子：星星
│   │   ├── particle-glow.png         # 粒子：辉光
│   │   ├── btn-start.png             # 按钮：开始
│   │   ├── btn-next.png              # 按钮：下一关
│   │   ├── panel-result.png          # 面板：结算弹窗
│   │   └── logo.png                  # 游戏 Logo
│   ├── audio/
│   │   ├── bgm-mountain.mp3          # 山野 BGM
│   │   ├── sfx-catch.mp3             # 接住目标字
│   │   ├── sfx-wrong.mp3             # 接住干扰字
│   │   ├── sfx-combo.mp3             # combo 触发
│   │   ├── sfx-boss-merge.mp3        # BOSS 拼合
│   │   └── sfx-level-clear.mp3       # 过关
│   └── fonts/
│       └── SourceHanSans-Bold.otf    # 思源黑体粗体
├── components/                        # React 页面组件
│   ├── HomePage.tsx                   # 首页
│   ├── WorldMap.tsx                   # 世界地图
│   ├── GameScreen.tsx                 # Phaser 游戏容器
│   └── ResultScreen.tsx              # 结算页
├── game/                              # Phaser 游戏逻辑
│   ├── scenes/
│   │   ├── BootScene.ts              # 资源预加载
│   │   ├── GameScene.ts              # 核心游戏场景
│   │   └── BossScene.ts             # BOSS 关场景
│   ├── objects/
│   │   ├── FallingChar.ts            # 下落字实体
│   │   ├── Catcher.ts                # 接收区
│   │   └── ZiLin.ts                  # 字灵（表情切换）
│   └── systems/
│       ├── ComboSystem.ts            # 连击系统
│       ├── LevelManager.ts           # 关卡管理
│       └── WeatherSystem.ts          # 天气效果
├── data/
│   ├── characters.json               # 字库（MVP：山水火木土石 + 干扰字）
│   └── levels.json                   # 关卡配置（6 关）
├── services/
│   └── ai.ts                         # AI 故事生成 + TTS
├── App.tsx
└── main.tsx
```

---

## 资产规格约定

B 按以下规格出图，A 直接使用无需二次处理：

### 图片

| 资产 | 尺寸（px） | 格式 | 说明 |
|------|-----------|------|------|
| 背景（灰白版） | 1080 x 1920 | PNG | 山野场景，灰白水墨，低对比 |
| 背景（彩色版） | 1080 x 1920 | PNG | 同构图，彩色版本 |
| 字灵角色 | 200 x 200 | PNG 透明底 | Q 版小生物，3 个表情各一张 |
| 接收区/角色 | 160 x 80 | PNG 透明底 | 底部托盘或小人物 |
| 按钮 | 280 x 80 | PNG 透明底 | 圆角矩形，柔和配色 |
| 结算面板 | 640 x 800 | PNG 透明底 | 圆角面板底图 |
| 粒子贴图 | 32 x 32 | PNG 透明底 | 星星、光点各一张 |
| Logo | 600 x 200 | PNG 透明底 | 「仓颉学字」标题艺术字 |

### 音效

| 资产 | 时长 | 格式 | 说明 |
|------|------|------|------|
| BGM | 60-90 秒循环 | MP3 | 古风笛子/轻快风，可用 AI 生成 |
| 接住音效 | < 1 秒 | MP3 | 清脆叮咚 |
| 接错音效 | < 1 秒 | MP3 | 轻柔碎裂 |
| combo 音效 | < 1 秒 | MP3 | 递进和弦 |
| 过关音效 | 2-3 秒 | MP3 | 欢快短旋律 |
| BOSS 拼合 | 1-2 秒 | MP3 | 宏大合成音 |

### 配色方案（B 定好后 A 代码里统一使用）

```
--color-bg:         #F5F0E8     // 页面底色（米白）
--color-primary:    #FF9F43     // 主色（暖橙，目标字）
--color-secondary:  #6C8EBF     // 辅色（灰蓝，干扰字）
--color-accent:     #FFD93D     // 强调色（金色，combo/能力字）
--color-text:       #2D3436     // 正文字色
--color-text-light: #636E72     // 辅助文字
--color-success:    #6BCB77     // 成功/正确
--color-panel:      #FFFFFF     // 面板背景
```

B 先确认配色，A 立即写入 CSS 变量，后续全局统一。

---

## 两天时间线

### Day 1：核心游戏跑通

#### 上午（4 小时）

| 时段 | A 程序 | B 美术 |
|------|--------|--------|
| 0-1h | Vite + React + Phaser 3 脚手架搭建；Git 仓库初始化 | 确定配色方案 + 字体；设计字灵角色（3 个表情） |
| 1-2h | Phaser GameScene：字下落 + 接收区移动 + 碰撞检测 | 画山野背景（灰白版 + 彩色版） |
| 2-3h | 字的类型判定（目标/干扰）+ 基础得分逻辑 | 画接收区角色 + 粒子贴图 |
| 3-4h | 关卡 JSON 配置加载 + 6 关数据编写 | 画按钮 + 面板 + Logo |

**4h 检查点**：用占位色块能跑通一关（字掉下来、能接住、能判对错）。B 的第一批素材提交到 Git。

#### 下午（4 小时）

| 时段 | A 程序 | B 美术 |
|------|--------|--------|
| 4-5h | 替换占位素材为真实资产；React 首页 + 世界地图页面 | 找/做音效（推荐 freesound.org 或 AI 生成） |
| 5-6h | combo 系统 + 视觉特效（粒子、闪光、慢动作） | 做 BGM（AI 生成，如 Suno/Udio） |
| 6-7h | 过关结算页面（字卡展示 + 评价） | 调整素材色调一致性；补充缺失资产 |
| 7-8h | 关卡串联（第 1-5 关线性流程跑通） | 音效全部提交；协助测试 |

**8h 检查点**：5 关普通关能从首页开始完整玩完，有音效有特效有结算。素材全部到位。

#### 晚上（2-3 小时，看体力）

| A 程序 | B 美术 |
|--------|--------|
| BOSS 关逻辑（拆字拼合） | BOSS 相关素材（拼合动画帧）|
| 灰→彩色场景过渡效果 | 测试 + 记录 bug |

---

### Day 2：打磨 + AI + 演示

#### 上午（4 小时）

| 时段 | A 程序 | B 美术 |
|------|--------|--------|
| 0-1h | 字灵系统（角落显示 + 表情切换 + 文字气泡） | 字灵动画帧微调；结算页美化 |
| 1-2h | AI 故事生成对接（过关后调 API 展示一句话故事） | 首页精修（让第一眼印象好） |
| 2-3h | TTS 读音（Web Speech API）；字卡点击听读音 | 世界地图页美化 |
| 3-4h | 全流程联调：首页 → 地图 → 6 关 → BOSS → 结算 | 协助联调测试 |

**4h 检查点**：完整 6 关流程无 bug。AI 故事能生成。

#### 下午（3 小时：最终冲刺）

| 时段 | A 程序 | B 美术 |
|------|--------|--------|
| 4-5h | 部署到 Vercel；手机端适配测试 | 准备演示用截图/录屏 |
| 5-6h | bug 修复 + 性能优化 | 准备 PPT / 演示脚本 |
| 6-7h | 两人一起：走一遍完整演示流程，掐时间 | 同左 |

---

## 关键交接节点

| 时间 | 交接内容 | 方向 |
|------|---------|------|
| Day1 0h | A 建好 Git 仓库 + assets 目录结构 | A → B |
| Day1 0.5h | B 确认配色方案 | B → A |
| Day1 4h | B 提交第一批图片素材（背景、角色、按钮） | B → A |
| Day1 7h | B 提交音效 + BGM | B → A |
| Day1 8h | A 提供可玩版本供 B 测试 | A → B |
| Day2 3h | B 提交最终精修素材 | B → A |
| Day2 4h | 功能冻结（feature freeze），只修 bug | 双方 |

---

## B 的工具推荐

| 用途 | 推荐工具 | 说明 |
|------|---------|------|
| 角色/UI 设计 | Figma（免费） | 矢量设计，导出 PNG |
| 插画/背景 | Procreate / AI 绘图（Midjourney / SD） | Q 版风格 AI 生图 + 手动调整 |
| 音效 | freesound.org / Pixabay Audio | 免费音效库 |
| BGM | Suno / Udio | AI 生成音乐，描述风格即可 |
| 字体 | Google Fonts：Noto Sans SC Bold | 开源，覆盖全部汉字 |

---

## 风险预案

| 风险 | 应对 |
|------|------|
| B 素材来不及 | A 用纯色矩形 + CSS 样式先做，素材到了替换即可 |
| AI API 调不通 | 预写 5 句固定故事硬编码，演示时随机展示 |
| BOSS 关做不完 | 砍掉 BOSS，5 关普通关也能演示核心玩法 |
| 手机适配有问题 | 答辩用电脑演示，手机作为备选 |
| Phaser 踩坑 | 字的下落用 Phaser，UI 页面用纯 React，降低耦合 |

---

## MVP 验收清单

- [ ] 首页：Logo + 开始按钮 + 字灵打招呼
- [ ] 世界地图：山野世界 6 个关卡节点（可点击）
- [ ] 关卡 1-5：字下落 + 左右移动接住 + 目标/干扰判定
- [ ] 关卡 6（BOSS）：拆字拼合
- [ ] combo 特效：3/5/10 连击有视觉反馈
- [ ] 字灵：角落显示 + 接对/接错表情切换
- [ ] 过关结算：字卡 + 读音 + AI 故事 + 评价
- [ ] 灰→彩色：通关后背景变化
- [ ] 音效：接住/接错/combo/过关 至少 4 个
- [ ] BGM：山野世界 1 首
- [ ] 可通过 URL 访问（Vercel 部署）
