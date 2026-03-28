Viewed 20260328-unified-style-and-assets-guide.md:800-1213

文档中（特别是第 21、22、23 节）详细列出了本项目 **MVP 阶段需要交付的所有美术背景、音乐与音效资源**。同时，第 17 节定义了美术图片生成的“公式化”提示词框架。

为了方便您直接喂给 AI 生成工具，我将它们分类整理成了下面的表格，并根据文档要求为您组合了对应的**直接可用的英文提示词（Prompt）**。

---

### 一、 美术背景资源 (Backgrounds)

**美术图片生成公式：**
全局前缀（设定基础画风）+ 背景专用词（设定材质）+ 画面具体内容。
*(下面表格中的提示词已经为您拼接好了完整版，可直接复制至 Midjourney 或 NiJi 等工具中尝试)*

| 优先级 | 文件名 | 场景 | 生成提示词 (Prompt) |
| :--- | :--- | :--- | :--- |
| **P0** | `bg-home.png` | 首页 | `Eastern fairytale style, soft ink-wash background, cute stylized shapes, child-friendly mobile game art, gentle Chinese fantasy atmosphere, clean composition, warm golden highlights, storybook quality, misty watercolor mountains, rice-paper texture. A magical mountain world, half in grey mist and half in color, with falling glowing golden Chinese characters in the center, dreamy and soft.` |
| **P0** | `bg-worldmap.png` | 世界地图 | `Eastern fairytale style, soft ink-wash background, child-friendly mobile game art, gentle Chinese fantasy atmosphere, warm golden highlights. Vertical ancient scroll map layout, layers of mist and clouds, a flowing golden path, elegant negative space, low contrast.` |
| **P0** | `bg-mountain-gray.png` | 山野关卡<br>(灰白版) | `Eastern fairytale style, delicate soft grey ink-wash background, child-friendly mobile game art, storybook quality. Colorless mountains and still rivers, large empty space in the center, low saturation, elegant pale negative space, misty watercolor.` |
| **P0** | `bg-mountain-color.png` | 山野关卡<br>(修复版) | *(同构图衍生)* `Eastern fairytale style, soft ink-wash background, child-friendly mobile game art. Soft green mountains, pale blue river, warm light, warm golden highlights, blooming trees, clean composition, elegant negative space.` |
| **P1** | `bg-result.png` | 结算页 | `Eastern fairytale style, soft ink-wash background, child-friendly mobile game art. Very quiet, bright and warm space, rice-paper texture, designed to hold a large UI panel in the center, minimal details.` |
| **P1** | `bg-calibration.png` | 校准页 | `Eastern fairytale style, minimalist background, child-friendly mobile game art. Very clean, light cloud or faint ink texture, elegant negative space, purely decorative background.` |
| **P1** | `bg-settings.png` | 设置页 | `Eastern fairytale style, rice-paper texture, child-friendly mobile game art. Faint landscape silhouette in the back, extremely clean and calm, soft colors.` |
| **P2** | `bg-collection.png` | 图鉴页 | `Eastern fairytale style, close up of a magical glowing ancient book or rice paper, child-friendly mobile game art, quiet and clean.` |
| **P2** | `bg-boss-mountain.png`| BOSS 关 | `Eastern fairytale style, soft ink-wash background, child-friendly mobile game art. Epic but gentle mountain scenery, warm red and gold highlights, exciting but not scary, large empty space in the center for gameplay.` |

---

### 二、 背景音乐资源 (BGM)

**音乐核心要求：** “儿童友好的轻国风游戏音乐”。配器以笛子、木琴、短拨弦（古筝、琵琶）为主，避免厚重战鼓和电音。

| 优先级 | 文件名 | 场景 (时长) | 生成提示词 (Prompt 适用于 Suno/Udio) |
| :--- | :--- | :--- | :--- |
| **P0** | `bgm-home.mp3` | 首页 (60s) | `Playful Chinese fantasy game background music, dreamy and warm. Mid-slow tempo, gentle bamboo flute melody, guzheng and glockenspiel accents. Beginning of a magical oriental fairytale journey. Instrumental, loopable.` |
| **P0** | `bgm-worldmap.mp3` | 世界地图 (60s)| `Lighthearted Chinese fantasy puzzle game music. Light exploration rhythm, light percussion, marimba, and flowing bamboo flute. Stress-free advancing feeling, oriental fairytale atmosphere. Instrumental, loopable.` |
| **P0** | `bgm-mountain.mp3` | 关卡主BGM (60s) | `(已在上文提供：轻快、专注、有节奏感但不厚重的主关卡配乐)` |
| **P1** | `bgm-boss.mp3` | BOSS关 (45s)| `Rhythmic Chinese fantasy game music, faster tempo. More percussion and melody tension, exciting but not dark. Child-friendly adventure climax, bamboo flute and guzheng. Instrumental, loopable.` |
| **P1** | `bgm-result.mp3` | 结算页 (15s)| `Short 15 seconds, bright, rewarding, warm conclusion piece. Chinese fantasy instruments, gentle chime and bamboo flute, triumphant but very soft and cute. Instrumental.` |

---

### 三、 音效资源 (SFX)

**由于我们修改了“切字正确”的音效（采用了您要求的水果忍者利刃风）**，下表列出了其余需要补齐的互动音效。音效主要追求“发光纸张、轻铃音、柔和木质”质感。

| 优先级 | 文件名 | 场景 (时长) | 生成提示词 (Prompt 适用于 ElevenLabs/Audio大模型) |
| :--- | :--- | :--- | :--- |
| **P0** | `sfx-slash-wrong.mp3` | 错误切中 (0.3s) | `A very soft, unobtrusive game UI sound. Gentle error feedback, faint dull wood tap or a soft muffled ink drop. Not sharp, not annoying.` |
| **P0** | `sfx-combo-up.mp3` | 连击增长 (0.5s) | `Progressive rising mobile game UI sound, small magical golden chimes going up in pitch rapidly, satisfying and bright.` |
| **P0** | `sfx-level-clear.mp3` | 关卡胜利 (2s) | `Warm and rewarding level clear jingle, bright chime and a gentle 3-note melody, satisfying oriental fairytale feeling.` |
| **P0** | `sfx-btn-click.mp3` | 按钮点击 (0.2s) | `Soft and clean UI click, gentle paper folding or soft wood tap texture, extremely short, not metallic.` |
| **P1** | `sfx-unlock.mp3` | 节点解锁 (1s) | `Magical and bright UI sound, golden light shining, a satisfying 'heavy stone or seal locking into place' feeling, but bright and gentle.` |
| **P1** | `sfx-world-reveal.mp3`| 灰到彩修复 (2s)| `Magical ambiance sweep, fading mist melting into warm golden light sparkling, ceremonial, gentle and expanding.` |
| **P1** | `sfx-char-card.mp3` | 字卡翻开 (0.5s) | `Crisp paper flipping or parchment spreading sound, combined with a quick, light magical collection chime.` |
| **P1** | `sfx-boss-complete.mp3`| 解封成功 (1.5s)| `Large but gentle magical burst, bright grand calligraphy energy scattering, satisfying and warm, not scary.` |

---

### 四、 开场剧情动画 (视频生成)

文档第 23 节还规划了 `20-35 秒`的开场动画（如果是交给 AI 生成视频工具，如 Sora, Kling 或 Runway 等）。文档提供了非常详细的分镜：

*   **Shot 1 (无生气的世界):** `silent ancient Chinese landscape in soft grey ink-wash style, faded mountains, still river, drifting mist, magical but lifeless, child-friendly eastern fairytale...`
*   **Shot 2 (字雨降临):** `warm golden Chinese characters fall from the sky like gentle rain, glowing softly with calligraphy energy trails, magical healing atmosphere...`
*   **Shot 3 (字灵出现):** `a tiny cute ink spirit made of ink and golden light appears from floating characters, expressive eyes, soft glow, guiding the viewer...`
*   **Shot 4 (切开汉字):** `a finger traces a glowing golden calligraphy stroke in the air, the stroke slices through a large floating Chinese character, golden particles scatter...`
*   **Shot 5 (世界复苏):** `the painted mountain world comes back to life, grey ink turns into soft green mountains and pale blue river, warm golden light spreads...`

*(注：动画的台词与旁白也已在文档第 23.7 节给出，可直接搭配生成的短视频组装使用)*