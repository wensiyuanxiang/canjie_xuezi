# 仓颉学字 - 素材交付手册

日期：2026-03-28
目的：美术/音效全部素材的规格、文件名、AI 生成提示词。朋友照着这张表逐项交付即可。

---

## 全局风格锚定

所有图片素材使用同一个**风格前缀**，加在每条提示词前面：

```
Style prefix (图片):
cute chibi kawaii style, flat vector illustration, soft pastel macaron color palette,
rounded shapes with no sharp edges, gentle and healing atmosphere,
children's educational game art, clean simple composition, white or transparent background
```

所有音频素材使用同一个**风格前缀**：

```
Style prefix (音乐):
gentle, warm, child-friendly, Chinese traditional instruments mixed with modern arrangement,
soft and calming, suitable for children aged 6-12
```

---

## 一、配色方案（优先级 P0，Day1 第 1 小时交付）

| 色号 | 用途 | CSS 变量 | 参考色值 |
|------|------|---------|---------|
| 主色 | 目标字背景光晕、主按钮 | `--color-primary` | #FF9F43（暖橙） |
| 辅色 | 干扰字背景、次要信息 | `--color-secondary` | #6C8EBF（灰蓝） |
| 强调色 | combo 特效、能力字、金色彩蛋 | `--color-accent` | #FFD93D（金色） |
| 成功色 | 接对反馈、过关 | `--color-success` | #6BCB77（柔绿） |
| 底色 | 页面背景 | `--color-bg` | #F5F0E8（米白） |
| 正文色 | 标题文字 | `--color-text` | #2D3436（深灰） |
| 辅助文字 | 说明、提示 | `--color-text-light` | #636E72（中灰） |
| 面板色 | 弹窗、卡片背景 | `--color-panel` | #FFFFFF（白） |

> 以上为建议值，B 可根据整体感觉微调，确认后 A 统一写入 CSS 变量。

---

## 二、图片素材

### 2.1 游戏背景

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 1 | `bg-mountain-gray.png` | 1080x1920 | PNG | **P0** | 山野背景·灰白版（一纪·有形初始状态） | `{style prefix}, a misty Chinese ink wash landscape, grey mountains fading into white fog, a winding grey river at the bottom, bare grey trees, everything is desaturated and dreamlike, vertical mobile game background, no text, no characters` |
| 2 | `bg-mountain-color.png` | 1080x1920 | PNG | **P0** | 山野背景·彩色版（一纪·有形通关状态） | `{style prefix}, a vibrant Chinese landscape with green mountains, blue flowing river, cherry blossom trees in pink, small birds in the sky, warm golden sunlight, vertical mobile game background, colorful and lively, no text, no characters` |
| 3 | `bg-scroll-fragment.png` | 1080x1920 | PNG | P1 | 天书残页关背景 | `{style prefix}, deep navy blue starry sky with floating golden ancient Chinese scroll fragments, glowing particles, mystical cosmic atmosphere, translucent paper pieces drifting, vertical mobile game background, no text` |
| 4 | `bg-home.png` | 1080x1920 | PNG | **P0** | 首页背景 | `{style prefix}, a dreamy ancient Chinese world half in grey half in color, a giant ancient book in the center with golden light rays coming from it, Chinese characters raining down like gentle golden rain drops, vertical mobile game background, magical atmosphere` |
| 5 | `bg-worldmap.png` | 1080x1920 | PNG | **P0** | 世界地图背景 | `{style prefix}, a vertical ancient Chinese map scroll, parchment texture, eight small landscape vignettes arranged in a winding path from bottom to top, connected by a glowing golden dotted line, misty clouds between them, top-down view` |

### 2.2 角色 - 字灵

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 6 | `zilin-neutral.png` | 200x200 | PNG 透明底 | **P0** | 字灵·默认表情 | `{style prefix}, a tiny cute spirit creature made of ink and light, round body like a water droplet, two small dot eyes, a gentle smile, faintly glowing, holding a tiny golden brush, simple and adorable, centered on transparent background, single character design sheet` |
| 7 | `zilin-happy.png` | 200x200 | PNG 透明底 | **P0** | 字灵·开心（接对时） | `{style prefix}, same ink spirit creature, eyes squeezed shut in joy, big open smile, small sparkles around it, tiny arms raised in celebration, bouncing pose, transparent background` |
| 8 | `zilin-sad.png` | 200x200 | PNG 透明底 | **P0** | 字灵·惋惜（漏接时） | `{style prefix}, same ink spirit creature, droopy eyes looking down, small frown, a tiny sweat drop, slightly deflated body shape, sympathetic expression not angry, transparent background` |
| 9 | `zilin-surprised.png` | 200x200 | PNG 透明底 | P1 | 字灵·惊讶（金色彩蛋字） | `{style prefix}, same ink spirit creature, wide circular eyes, small O-shaped mouth, body slightly stretched upward, exclamation effect lines around it, transparent background` |
| 10 | `zilin-thinking.png` | 200x200 | PNG 透明底 | P2 | 字灵·思考（提示时） | `{style prefix}, same ink spirit creature, one eye slightly closed, looking upward, a tiny thought bubble with a question mark, hand on chin pose, transparent background` |

### 2.3 角色 - 接字人（接收区）

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 11 | `catcher.png` | 160x160 | PNG 透明底 | **P0** | 接字人角色（底部移动的小人） | `{style prefix}, a small cute chibi child character wearing ancient Chinese scholar robes in cream and gold colors, holding both hands up as if ready to catch something from above, front-facing, large head small body proportion, transparent background` |
| 12 | `catcher-tray.png` | 200x60 | PNG 透明底 | **P0** | 备选：云朵托盘（如果不用角色） | `{style prefix}, a small floating cloud with golden edges, like a fluffy cushion tray, simple shape, soft glowing edges, top-down slightly angled view, transparent background` |

### 2.4 道具 & 游戏元素

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 13 | `char-bg-target.png` | 80x80 | PNG 透明底 | **P0** | 目标字底板（暖色光晕） | `{style prefix}, a soft warm orange-golden circular glow, like a gentle halo or aura, slightly translucent, no text, centered, transparent background` |
| 14 | `char-bg-distractor.png` | 80x80 | PNG 透明底 | **P0** | 干扰字底板（冷色） | `{style prefix}, a soft grey-blue circular glow, subtle and muted, slightly translucent, no text, centered, transparent background` |
| 15 | `char-bg-ability.png` | 80x80 | PNG 透明底 | P1 | 能力字底板（闪光金色） | `{style prefix}, a bright golden starburst glow, radiant and sparkling, like a magical power-up, slightly translucent, no text, centered, transparent background` |
| 16 | `char-bg-golden.png` | 80x80 | PNG 透明底 | P2 | 金色彩蛋字底板 | `{style prefix}, an ornate golden frame with tiny ancient Chinese cloud patterns, glowing and prestigious, like a rare treasure, transparent background` |
| 17 | `ability-fire.png` | 120x120 | PNG 透明底 | P1 | 能力图标：焚字（火） | `{style prefix}, a cute stylized flame icon, warm orange-red gradient, friendly and non-threatening, rounded flame shape, transparent background` |
| 18 | `scroll-fragment.png` | 100x140 | PNG 透明底 | P1 | 天书残页道具图标 | `{style prefix}, a torn piece of ancient golden Chinese scroll paper, slightly curled edges, faint Chinese character traces on it, glowing softly, transparent background` |

### 2.5 粒子特效贴图

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 19 | `particle-star.png` | 32x32 | PNG 透明底 | **P0** | 星星粒子（combo/通关） | 手绘或 Figma 画一个四角星，金色 #FFD93D，柔和边缘 |
| 20 | `particle-glow.png` | 32x32 | PNG 透明底 | **P0** | 辉光粒子（接住时） | 手绘或 Figma 画一个圆形渐变光点，白色中心→透明边缘 |
| 21 | `particle-ink.png` | 32x32 | PNG 透明底 | P1 | 墨点粒子（接错碎裂） | 手绘或 Figma 画一个不规则墨点，灰蓝色 #6C8EBF |
| 22 | `particle-petal.png` | 24x24 | PNG 透明底 | P2 | 花瓣粒子（通关庆祝） | 手绘或 Figma 画一片简化花瓣，粉色 |

> 粒子贴图极小，不建议 AI 生成，手绘或 Figma 几何形状最快最准。

### 2.6 UI 组件

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 23 | `logo.png` | 600x200 | PNG 透明底 | **P0** | 游戏 Logo「仓颉学字」 | `{style prefix}, Chinese game title logo text "仓颉学字", stylized calligraphy mixed with cute rounded modern font, golden and warm brown colors, small ink spirit mascot sitting on the last character, transparent background` |
| 24 | `btn-primary.png` | 280x80 | PNG 透明底 | **P0** | 主按钮底板（开始游戏等） | `{style prefix}, a rounded rectangle button shape, warm orange gradient (#FF9F43 to #E17B2F), soft shadow, no text, transparent background` |
| 25 | `btn-secondary.png` | 280x80 | PNG 透明底 | P1 | 次要按钮底板 | `{style prefix}, a rounded rectangle button shape, soft cream white with thin golden border, no text, transparent background` |
| 26 | `panel-result.png` | 640x800 | PNG 透明底 | **P0** | 结算弹窗面板底图 | `{style prefix}, a large rounded rectangle panel, parchment paper texture, golden decorative border with subtle Chinese cloud patterns at corners, warm cream background, no text, transparent edges` |
| 27 | `panel-charcard.png` | 200x260 | PNG 透明底 | **P0** | 字卡底板（结算页展示生字） | `{style prefix}, a small vertical card shape like a Chinese seal stamp, cream paper texture, thin red border, space in center for a large character, no text, transparent background` |
| 28 | `icon-level-locked.png` | 48x48 | PNG 透明底 | **P0** | 关卡节点·未解锁 | Figma：半透明灰色圆形，带锁图标 |
| 29 | `icon-level-current.png` | 48x48 | PNG 透明底 | **P0** | 关卡节点·当前 | Figma：橙色呼吸发光圆形 |
| 30 | `icon-level-done.png` | 48x48 | PNG 透明底 | **P0** | 关卡节点·已通关 | Figma：金色实心圆形，带勾 |
| 31 | `icon-scroll-node.png` | 48x48 | PNG 透明底 | P1 | 天书残页地图节点 | Figma：金色卷轴小图标 |
| 32 | `icon-boss.png` | 64x64 | PNG 透明底 | P1 | BOSS 关卡节点 | Figma：红金色圆形，带星标 |

### 2.7 评价符号

| # | 文件名 | 尺寸 | 格式 | 优先级 | 描述 | AI 提示词 |
|---|--------|------|------|--------|------|----------|
| 33 | `rank-seed.png` | 80x80 | PNG 透明底 | **P0** | 评价·种子（基础过关） | `{style prefix}, a tiny cute seed with a small sprout, brown and green, simple and charming, transparent background` |
| 34 | `rank-sprout.png` | 80x80 | PNG 透明底 | **P0** | 评价·幼苗（接住率>=70%） | `{style prefix}, a small green sprout with two leaves, growing from soil, fresh and vibrant, transparent background` |
| 35 | `rank-tree.png` | 80x80 | PNG 透明底 | **P0** | 评价·大树（接住率>=90%） | `{style prefix}, a beautiful small tree with full canopy, golden fruits, birds on branches, lush and glowing, transparent background` |

---

## 三、音效素材

### 3.1 背景音乐（BGM）

| # | 文件名 | 时长 | 格式 | 优先级 | 描述 | Suno/Udio 提示词 |
|---|--------|------|------|--------|------|-----------------|
| 1 | `bgm-mountain.mp3` | 60-90s 循环 | MP3 | **P0** | 山野世界 BGM | `gentle Chinese bamboo flute (dizi) melody, flowing like a mountain stream, soft guzheng arpeggios in background, light percussion, peaceful and magical, suitable for children's game, loop-friendly ending, 90 bpm, instrumental only` |
| 2 | `bgm-home.mp3` | 60s 循环 | MP3 | **P0** | 首页/主菜单 BGM | `warm and inviting Chinese folk melody, soft xiao flute with gentle pipa plucking, dreamy and magical atmosphere like opening an ancient storybook, 80 bpm, instrumental, child-friendly, loop-friendly` |
| 3 | `bgm-worldmap.mp3` | 60s 循环 | MP3 | P1 | 世界地图 BGM（可复用 bgm-home） | `adventurous yet gentle Chinese orchestral piece, erhu leading melody with light drums, sense of journey and exploration, hopeful tone, 85 bpm, instrumental, loop-friendly` |
| 4 | `bgm-boss.mp3` | 60s 循环 | MP3 | P1 | BOSS 关 BGM | `exciting but not scary Chinese percussion and strings, building tension with taiko drums, dramatic erhu, fast pipa runs, energetic but child-friendly, 120 bpm, instrumental, loop-friendly` |
| 5 | `bgm-scroll.mp3` | 60s 循环 | MP3 | P2 | 天书残页关 BGM | `ethereal and mystical Chinese music, celestial bells and chimes, slow guqin melody floating in reverb, cosmic and magical atmosphere, 70 bpm, instrumental, loop-friendly` |
| 6 | `bgm-result.mp3` | 15-20s | MP3 | P1 | 过关结算页（不循环，一次性播放） | `cheerful short Chinese celebration melody, happy erhu and dizi duet, light clapping percussion, triumphant ending chord, joyful and rewarding, 100 bpm, 15 seconds` |

### 3.2 音效（SFX）

| # | 文件名 | 时长 | 格式 | 优先级 | 描述 | 来源建议 |
|---|--------|------|------|--------|------|---------|
| 7 | `sfx-catch-correct.mp3` | <0.5s | MP3 | **P0** | 接住目标字 | Suno: `bright cheerful chime ding, single note, crystal clear, like catching a star, very short` 或 freesound.org 搜 "chime ding positive" |
| 8 | `sfx-catch-wrong.mp3` | <0.5s | MP3 | **P0** | 接住干扰字 | Suno: `soft dull thud with gentle glass crack, not harsh or scary, muffled and short` 或 freesound.org 搜 "soft error gentle" |
| 9 | `sfx-miss.mp3` | <0.3s | MP3 | P1 | 目标字落地（轻微） | freesound.org 搜 "soft drop whoosh"，要极轻的，几乎听不到 |
| 10 | `sfx-combo-3.mp3` | <1s | MP3 | **P0** | 3 连击 | Suno: `ascending three-note chime arpeggio, C-E-G, bright and encouraging, short` 或 freesound.org 搜 "combo ascending chime" |
| 11 | `sfx-combo-5.mp3` | <1s | MP3 | P1 | 5 连击 | Suno: `ascending five-note sparkle arpeggio with light shimmer, excited and magical, short` |
| 12 | `sfx-combo-10.mp3` | <1.5s | MP3 | P1 | 10 连击 | Suno: `triumphant short fanfare with sparkle effects, golden and glorious, climactic, 1 second` |
| 13 | `sfx-level-clear.mp3` | 2-3s | MP3 | **P0** | 过关成功 | Suno: `short victory jingle, happy ascending melody with final bright chord, children's game style, 2 seconds` |
| 14 | `sfx-boss-merge.mp3` | 1-2s | MP3 | P1 | BOSS 拆字拼合成功 | Suno: `powerful magical merge sound, two tones combining into one resonant chord, with shimmer and impact, epic but child-friendly, 1.5 seconds` |
| 15 | `sfx-ability-fire.mp3` | 1s | MP3 | P1 | 能力触发：焚字 | freesound.org 搜 "fire whoosh cartoon"，要Q版不可怕的 |
| 16 | `sfx-scene-reveal.mp3` | 2-3s | MP3 | P1 | 场景变化（灰→彩色渐显） | Suno: `magical reveal sound, gentle orchestral swell with sparkle chimes, like a world coming to life, 2.5 seconds` |
| 17 | `sfx-btn-click.mp3` | <0.3s | MP3 | **P0** | 按钮点击 | freesound.org 搜 "UI click soft pop"，要柔软的 |
| 18 | `sfx-char-tts.mp3` | - | - | **P0** | 汉字读音 | 代码用 Web Speech API 实时生成，**不需要 B 提供** |

---

## 四、字体

| # | 文件名 | 格式 | 优先级 | 来源 | 说明 |
|---|--------|------|--------|------|------|
| 1 | `NotoSansSC-Bold.otf` | OTF | **P0** | [Google Fonts](https://fonts.google.com/noto/specimen/Noto+Sans+SC) | 游戏内汉字显示，粗体，覆盖全部常用字 |
| 2 | `NotoSansSC-Regular.otf` | OTF | P1 | 同上 | UI 文字、说明文字 |

> 字体直接从 Google Fonts 下载即可，不需要 AI 生成。

---

## 五、交付清单 & 优先级汇总

### P0（Day1 必须交付，缺了游戏跑不起来）

| 类型 | 数量 | 文件 |
|------|------|------|
| 背景 | 3 张 | `bg-mountain-gray`, `bg-mountain-color`, `bg-home` |
| 角色 | 4 张 | `zilin-neutral`, `zilin-happy`, `zilin-sad`, `catcher`（或 `catcher-tray`） |
| 道具 | 2 张 | `char-bg-target`, `char-bg-distractor` |
| 粒子 | 2 张 | `particle-star`, `particle-glow` |
| UI | 6 张 | `logo`, `btn-primary`, `panel-result`, `panel-charcard`, `icon-level-current`, `icon-level-done` |
| 评价 | 3 张 | `rank-seed`, `rank-sprout`, `rank-tree` |
| BGM | 2 首 | `bgm-mountain`, `bgm-home` |
| 音效 | 5 个 | `sfx-catch-correct`, `sfx-catch-wrong`, `sfx-combo-3`, `sfx-level-clear`, `sfx-btn-click` |
| 字体 | 1 个 | `NotoSansSC-Bold.otf` |
| **总计** | **28 项** | |

### P1（Day1 晚上或 Day2 上午交付，提升完整度）

| 类型 | 数量 | 文件 |
|------|------|------|
| 背景 | 2 张 | `bg-scroll-fragment`, `bg-worldmap` |
| 角色 | 1 张 | `zilin-surprised` |
| 道具 | 3 张 | `char-bg-ability`, `ability-fire`, `scroll-fragment` |
| UI | 4 张 | `btn-secondary`, `icon-level-locked`, `icon-scroll-node`, `icon-boss` |
| BGM | 3 首 | `bgm-worldmap`, `bgm-boss`, `bgm-result` |
| 音效 | 6 个 | `sfx-miss`, `sfx-combo-5`, `sfx-combo-10`, `sfx-boss-merge`, `sfx-ability-fire`, `sfx-scene-reveal` |
| 字体 | 1 个 | `NotoSansSC-Regular.otf` |
| **总计** | **20 项** | |

### P2（有时间再做，锦上添花）

| 类型 | 数量 | 文件 |
|------|------|------|
| 角色 | 1 张 | `zilin-thinking` |
| 道具 | 1 张 | `char-bg-golden` |
| 粒子 | 2 张 | `particle-ink`, `particle-petal` |
| BGM | 1 首 | `bgm-scroll` |
| **总计** | **5 项** | |

---

## 六、交付目录结构

B 将文件放入以下目录，**文件名必须与表格一致**（全小写，短横线分隔）：

```
src/assets/
├── images/
│   ├── bg/
│   │   ├── bg-mountain-gray.png
│   │   ├── bg-mountain-color.png
│   │   ├── bg-scroll-fragment.png
│   │   ├── bg-home.png
│   │   └── bg-worldmap.png
│   ├── character/
│   │   ├── zilin-neutral.png
│   │   ├── zilin-happy.png
│   │   ├── zilin-sad.png
│   │   ├── zilin-surprised.png
│   │   ├── zilin-thinking.png
│   │   ├── catcher.png
│   │   └── catcher-tray.png
│   ├── game/
│   │   ├── char-bg-target.png
│   │   ├── char-bg-distractor.png
│   │   ├── char-bg-ability.png
│   │   ├── char-bg-golden.png
│   │   ├── ability-fire.png
│   │   └── scroll-fragment.png
│   ├── particle/
│   │   ├── particle-star.png
│   │   ├── particle-glow.png
│   │   ├── particle-ink.png
│   │   └── particle-petal.png
│   ├── ui/
│   │   ├── logo.png
│   │   ├── btn-primary.png
│   │   ├── btn-secondary.png
│   │   ├── panel-result.png
│   │   ├── panel-charcard.png
│   │   ├── icon-level-locked.png
│   │   ├── icon-level-current.png
│   │   ├── icon-level-done.png
│   │   ├── icon-scroll-node.png
│   │   └── icon-boss.png
│   └── rank/
│       ├── rank-seed.png
│       ├── rank-sprout.png
│       └── rank-tree.png
├── audio/
│   ├── bgm/
│   │   ├── bgm-mountain.mp3
│   │   ├── bgm-home.mp3
│   │   ├── bgm-worldmap.mp3
│   │   ├── bgm-boss.mp3
│   │   ├── bgm-scroll.mp3
│   │   └── bgm-result.mp3
│   └── sfx/
│       ├── sfx-catch-correct.mp3
│       ├── sfx-catch-wrong.mp3
│       ├── sfx-miss.mp3
│       ├── sfx-combo-3.mp3
│       ├── sfx-combo-5.mp3
│       ├── sfx-combo-10.mp3
│       ├── sfx-level-clear.mp3
│       ├── sfx-boss-merge.mp3
│       ├── sfx-ability-fire.mp3
│       ├── sfx-scene-reveal.mp3
│       └── sfx-btn-click.mp3
└── fonts/
    ├── NotoSansSC-Bold.otf
    └── NotoSansSC-Regular.otf
```

---

## 七、注意事项

1. **一致性最重要**：字灵的 5 张表情图必须是同一个角色，只换表情。建议先画好 neutral 版确认风格，再派生其他表情。
2. **背景要"安静"**：游戏进行中背景不能抢汉字的注意力。灰白版低对比，彩色版也不要太艳。
3. **所有 PNG 必须透明底**（背景图除外）：AI 生成的图通常有白底，需要手动抠图或用 remove.bg 处理。
4. **音效避免惊吓**：所有音效要柔和，不要尖锐的蜂鸣或突然的巨响。目标用户是 6 岁小孩。
5. **BGM 循环点**：用 Suno 生成后，在 Audacity 里微调头尾衔接，确保循环播放不突兀。
6. **文件大小控制**：单张 PNG 不超过 500KB，单个 MP3 不超过 2MB。Web 加载速度优先。
