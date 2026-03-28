# 仓颉学字 - 统一风格与素材制作规范

日期：2026-03-28
目的：为图片与音乐制作提供一套统一、完整、可执行的风格规范，确保地图、主界面、道具、角色、背景音乐、音效在同一个世界观和审美体系下完成。

适用对象：

- 美术设计
- UI 设计
- 动效设计
- 音乐与音效制作

---

## 一、最终风格结论

本项目统一采用以下风格方向：

**东方童话卡通**

更具体的执行公式：

**轻水墨背景 + Q版卡通角色/UI + 金色书法能量特效**

这套风格用于统一以下全部内容：

- 首页
- 世界地图
- 关卡背景
- 角色与字灵
- 道具与图标
- 按钮与面板
- 背景音乐
- 音效

---

## 二、为什么不用纯国潮水墨或纯儿童卡通

### 2.1 不采用纯国潮水墨

原因：

- 气质好，但偏静、偏雅，不够有游戏反馈感
- 容易做得过于空灵，削弱“切字”的操作爽感
- 对儿童用户来说，亲和力和识别度可能不足

### 2.2 不采用纯儿童卡通

原因：

- 足够亲和，但缺少“汉字世界”和“文化感”
- 容易变成普通早教产品视觉
- 在比赛或展示场景下辨识度偏弱

### 2.3 采用混合风格的原因

因为这个项目同时需要：

- 东方文字气质
- 儿童亲和力
- 操作爽感
- 商业游戏包装感

所以必须分层统一：

- 背景层偏水墨
- 角色层偏卡通
- 交互层偏金色能量书法

---

## 三、风格锚点

所有素材都必须围绕这 5 个关键词展开：

- 东方童话
- 柔和治愈
- 商业手游质感
- 汉字能量感
- 儿童可亲近

禁止出现以下气质：

- 写实厚重
- 硬核武侠
- 赛博科技
- 廉价早教 App
- 浓艳俗气
- 恐怖、压迫、尖锐

---

## 四、视觉分层规则

为了统一整体视觉，所有画面必须按三层理解：

### 4.1 背景层

定位：

- 世界观氛围
- 承担“山河复苏”的叙事
- 不能抢汉字识别和手势操作

风格要求：

- 轻水墨
- 低对比
- 雾感
- 宣纸感
- 中国山水童话化，而不是严肃古画复刻

适用内容：

- 首页远景
- 地图底图
- 山野世界关卡背景
- 过场背景

### 4.2 中景与角色层

定位：

- 让游戏“活”起来
- 提供亲和力和情绪表达

风格要求：

- Q版
- 圆润
- 轮廓明确
- 颜色比背景更清晰
- 表情丰富但不过度夸张

适用内容：

- 字灵
- 地图节点装饰
- 图鉴小图
- 关卡装饰物

### 4.3 交互与特效层

定位：

- 承担“爽感”
- 让切字动作和命中反馈有明确价值感

风格要求：

- 金色书法能量
- 墨迹、裂纸、飞字、金粉
- 发光感明确，但不刺眼
- 统一偏暖色

适用内容：

- 指尖轨迹
- 切字命中
- 连击反馈
- 解锁动画
- 世界修复动画

---

## 五、整体美术方向

### 5.1 推荐总风格

请按如下方向制作：

- 主背景像“儿童能进入的山水童话世界”
- UI 像“卷轴、纸张、木牌、印章”构成的游戏系统
- 特效像“文字被重新点亮”
- 角色像“温柔可爱的陪伴精灵”

整体不是博物馆风，也不是教育插图风，而是：

**轻商业手游级的国风童话 UI**

### 5.2 视觉参考心智

如果要用一句话描述给设计师：

`像一个能在手机上玩的东方童话冒险游戏，而不是一个识字课件。`

---

## 六、色彩系统

### 6.1 主色板

统一颜色建议如下：

```css
--color-bg: #F5F0E8;
--color-ink: #2D3436;
--color-primary: #FF9F43;
--color-secondary: #6C8EBF;
--color-accent: #FFD93D;
--color-success: #6BCB77;
--color-panel: #FFFDF8;
--color-panel-border: #E6D7B9;
--color-mist: #DFE6E9;
--color-warm-brown: #9C6B3F;
--color-soft-red: #D97D7D;
```

### 6.2 配色职责

- 米白：全局底色、宣纸底
- 深灰墨色：正文与主汉字笔画
- 暖橙：主按钮、目标字强调
- 灰蓝：干扰字、冷却状态、次要信息
- 金黄：能量、连击、解锁、切字特效
- 柔绿：成功、修复完成
- 暖棕：卷轴、木牌、标题装饰

### 6.3 配色原则

- 背景低对比
- 交互高对比
- 金色只用于“重要且有价值”的反馈
- 不用高饱和紫色、荧光蓝、荧光绿
- 不做黑底霓虹风

---

## 七、材质语言

为了统一所有页面与道具，素材必须反复使用以下材质语义：

- 宣纸
- 卷轴
- 木牌
- 印章
- 云纹
- 金粉
- 墨迹

应用规则：

- 面板像纸，不像塑料
- 按钮像精致木牌或发光纸片，不像系统按钮
- 图标像印章或纸符，不像扁平办公图标
- 关卡节点像章印，不像现代 UI 圆点

---

## 八、角色风格

### 8.1 字灵

定位：

- 陪伴者
- 情绪提示者
- 游戏世界里的文字小精灵

设计要求：

- 小巧、圆润、可爱
- 主体像“墨滴 + 光点”的结合
- 有一点古风书灵感，但不能复杂
- 眼睛和表情要清楚
- 不要做成人拟人化

表情方向：

- 默认：温和、陪伴
- 开心：接对字时
- 惋惜：划错或漏字时
- 惊讶：解锁或彩蛋时
- 思考：提示时

### 8.2 玩家代理形象

如果需要接字人或角色 icon：

- 用小书生 / 小执笔者 / 云朵托盘三选一
- 推荐优先使用“云朵托盘”或“简化小执笔者”
- 不建议做复杂人物立绘

原因：

- 本作核心不是角色扮演，而是手势输入与汉字互动

---

## 九、页面风格规范

### 9.1 首页

风格目标：

- 一眼看出“汉字世界正在复苏”
- 有东方感
- 有商业游戏开屏感

视觉要素：

- 灰白山野远景
- 中央发光古书或金色字雨
- Logo 在上方
- 字灵在中下区域引导
- 主按钮要显眼、有光泽、有温度

氛围关键词：

- 梦幻
- 柔和
- 神秘但不高冷

### 9.2 世界地图

风格目标：

- 像一张正在被修复的山水卷轴
- 让玩家感到“我在推进章节”

视觉要素：

- 卷轴式纵向地图
- 云雾分隔
- 金色路径线
- 节点像印章
- 已修复区域从灰白变彩色

节点规则：

- 当前关卡：暖橙金色呼吸发光
- 已通关：金色印记
- 未解锁：灰白锁印
- BOSS：更大、更厚重的红金印章

### 9.3 设置页

风格目标：

- 干净、可信、精致
- 不跳出主世界

视觉要素：

- 宣纸面板
- 金边卡片
- 简洁图标
- 少量云纹和木纹装饰

设置页不能像浏览器原生表单页。

### 9.4 图鉴页

风格目标：

- 像一本孩子正在收集的汉字图册
- 有“成长记录”的价值感

视觉要素：

- 小字卡
- 纸张边框
- 已掌握状态有金印或绿色记号
- 点击展开时像翻卡或展卷

### 9.5 结算页

风格目标：

- 要有奖励感
- 要有学习感
- 要有“我修复了世界”的成就感

视觉要素：

- 大型卷轴面板
- 新学字卡高亮
- 世界变化前后对比小图
- 评价图标可爱但不要幼稚

---

## 十、关卡场景与背景规范

### 10.1 山野世界背景

基础要求：

- 灰白版和修复版必须是同一构图
- 方便做“从灰到彩”的变化

灰白版特点：

- 山形、河道、树影都在
- 但低饱和、低对比、像未完成的画卷

修复版特点：

- 山体转为青绿和暖灰
- 河流有淡蓝色
- 树木和草地有柔和色彩
- 加入少量鸟、花、微光

注意：

- 再美也不能抢汉字
- 中间主战区尽量留出干净空间

### 10.2 摄像头玩法适配

因为关卡中有手势轨迹与下落/飞行的汉字：

- 背景必须“安静”
- 避免复杂花纹在中部区域堆叠
- 天空和雾区是主要留白区

---

## 十一、UI 组件风格规范

### 11.1 按钮

统一特征：

- 圆角
- 柔和阴影
- 暖色渐变或米白金边
- 有材质感
- 不做纯扁平系统按钮

主按钮：

- 暖橙到深暖橙渐变
- 微微发光
- 用于“开始修复”“下一关”

次按钮：

- 米白底、金边或浅棕边
- 用于“返回”“设置”“图鉴”

### 11.2 面板

统一特征：

- 宣纸纹理
- 四角有简化云纹
- 有细金边或暖棕边
- 中间留足内容空间

### 11.3 图标

统一特征：

- 线条简洁
- 圆润
- 少量装饰
- 更像印章小图，而不是系统 UI icon

---

## 十二、道具与收集物风格规范

道具必须服务于“文字复苏”的主题，不做随机西式奇幻物件。

推荐道具语义：

- 卷轴残片
- 金色字牌
- 印章节点
- 小纸符
- 云朵托盘
- 墨滴能量

风格要求：

- 都属于同一世界
- 统一材质和配色
- 不要一部分像仙侠，一部分像儿童贴纸

### 12.1 推荐道具风格

卷轴残片：

- 金边旧纸
- 带轻微发光
- 有残缺感但不破败肮脏

字牌：

- 纸牌或木牌形态
- 中央大字清晰
- 周围有微光或边框

能力物件：

- 以“字能量”形式表现
- 不要做成武器
- 例如火字能力像温暖的火纹符，不像攻击技能图标

---

## 十三、特效风格规范

### 13.1 总原则

特效统一为：

**金色书法能量 + 墨迹辅助**

不是火花爆炸风，也不是魔法 RPG 风。

### 13.2 切字命中特效

建议元素：

- 金色笔锋切线
- 短暂停顿
- 字体裂开
- 金粉四散
- 少量纸屑或墨迹
- 飞入收集槽

### 13.3 错误反馈特效

建议元素：

- 灰蓝小碎点
- 轻微晃动
- 字灵提示
- 不要红色大叉和强烈报警

### 13.4 连击特效

建议元素：

- 屏幕边缘暖金呼吸光
- 小型飞字
- 金色印章跳出
- 粒子略增

### 13.5 世界修复特效

建议元素：

- 灰白雾气散开
- 彩色从局部晕染出来
- 金线沿地图或背景蔓延
- 最后出现轻微发光停留

---

## 十四、音乐风格规范

### 14.1 总体音乐方向

不要做纯古风纯器乐，也不要做普通儿童儿歌。

统一方向：

**儿童友好的轻国风游戏音乐**

音乐气质应该同时具备：

- 东方感
- 轻快感
- 温暖感
- 探索感

### 14.2 配器建议

可用乐器：

- 笛子 / 箫
- 古筝
- 琵琶
- 木琴
- 轻打击
- 柔和 pad
- 轻钟琴 / bell

不建议过量使用：

- 厚重战鼓
- 悲怆二胡主旋律
- 过度史诗弦乐
- EDM 节奏
- 赛博电子音色

### 14.3 音乐制作原则

- 旋律简洁易记
- 节奏要有流动感
- 不宜太慢太空
- 不要过于密集，避免干扰识字专注
- 可循环且不突兀

---

## 十五、分场景 BGM 设计建议

### 15.1 首页 BGM

情绪：

- 梦幻
- 温暖
- 有开启旅程的感觉

建议：

- 速度中慢
- 笛子主旋律
- 古筝或钟琴点缀
- 柔和 pad 铺底

关键词：

- 打开古书
- 字雨降临
- 准备启程

### 15.2 地图 BGM

情绪：

- 轻探索
- 有前进感
- 不焦虑

建议：

- 比首页更有节奏
- 轻打击加入
- 旋律更清晰

关键词：

- 山路展开
- 卷轴延伸
- 章节推进

### 15.3 关卡 BGM

情绪：

- 轻快
- 专注
- 有操作节奏感

建议：

- 节拍明显但轻
- 不能抢音效
- 用笛子、木琴、短拨弦做律动

关键词：

- 划切
- 飞字
- 节奏感

### 15.4 BOSS / 最后一关 BGM

情绪：

- 稍有张力
- 仍然儿童友好
- 有“快完成了”的高潮感

建议：

- 加一些鼓点和更鲜明的旋律推进
- 不要压迫、不要黑暗

### 15.5 结算 BGM

情绪：

- 奖励
- 放松
- 小小荣耀感

建议：

- 10-20 秒短音乐
- 明亮收束
- 可和过关音效衔接

---

## 十六、音效风格规范

### 16.1 总体方向

音效统一为：

**柔和、清晰、偏纸张与金光质感**

不是硬击打，不是电子 UI，不是夸张卡通爆炸。

### 16.2 关键音效气质

正确切中：

- 清亮
- 有“切开发光纸片”的感觉
- 短促

错误切中：

- 轻微
- 柔和
- 不刺耳

连击：

- 递进
- 有上升感
- 带一点闪光感

通关：

- 温暖
- 奖励明确
- 不要太长

解锁：

- 神奇、轻亮
- 有“文字归位”的感觉

按钮点击：

- 柔软
- 干净
- 不要系统哒哒声

### 16.3 音效材质建议

可参考的质感：

- 纸张滑切
- 小铃声
- 温柔木质敲击
- 细碎金属亮点
- 轻墨滴扩散感

避免：

- 重金属碰撞
- 激烈刀剑声
- 尖锐错误提示
- 西式法术爆炸

---

## 十七、图片生成与绘制提示词方向

### 17.1 统一视觉提示词前缀

所有图片生成建议统一加入以下方向：

```text
Eastern fairytale style, soft ink-wash background, cute stylized shapes, child-friendly mobile game art,
gentle Chinese fantasy atmosphere, clean composition, warm golden highlights, rounded forms,
storybook quality, light commercial game UI feeling
```

### 17.2 背景类追加词

```text
misty watercolor mountains, rice-paper texture, low contrast, elegant negative space, calm and clean gameplay background
```

### 17.3 角色与 UI 类追加词

```text
cute chibi design, rounded silhouette, expressive face, polished mobile game asset, soft shadow, clean edges
```

### 17.4 特效与道具类追加词

```text
golden calligraphy energy, glowing ink strokes, magical paper fragments, soft particles, warm luminous details
```

---

## 十八、文件交付与一致性要求

### 18.1 一致性优先级

在本项目中，一致性高于单张素材“好不好看”。

如果某张图单独看很漂亮，但与其他页面气质不一致，视为不合格。

### 18.2 必须统一的内容

- 颜色体系
- 轮廓圆润度
- 材质语言
- 阴影方式
- 发光方式
- 金色使用方式
- 云纹和装饰密度

### 18.3 交付前自查

请每次交付前检查：

- 这张图是否属于同一个世界
- 是否会抢游戏中的汉字
- 是否过暗、过艳、过花
- 是否与首页、地图、关卡能连成一体

---

## 十九、制作优先级建议

### P0 先做

- 首页背景
- 山野关卡背景灰白版
- 山野关卡背景修复版
- 世界地图底图
- Logo
- 主按钮 / 次按钮
- 字灵 3 个基础表情
- 关卡节点图标
- 基础金色切字特效素材
- 首页 / 地图 / 关卡 BGM
- 正确 / 错误 / 连击 / 通关 / 按钮音效

### P1 再做

- 图鉴页装饰
- 结算页高级面板
- BOSS 节点与 BOSS 过场素材
- 世界修复附加动效素材
- 解锁音效
- 结算短 BGM

---

## 二十、最终统一口径

请所有参与素材制作的人统一记住下面这句话：

**这不是一个早教 App，也不是一个严肃国风展示页。**

**它是一款面向孩子的东方童话体感汉字游戏。**

最终统一执行口径：

- 背景：轻水墨东方童话
- 角色：Q版卡通陪伴感
- UI：卷轴纸张木牌印章
- 特效：金色书法能量 + 墨迹辅助
- 音乐：儿童友好的轻国风游戏音乐
- 音效：纸张、金光、柔和清亮

如果后续出现风格选择冲突，全部以本文档为准。

---

## 二十一、背景交付物列表

以下背景为本轮 MVP 建议交付内容，优先保证首页、地图、山野关卡三大场景完整。

### 21.1 图片背景交付原则

- 全部为竖屏移动端构图
- 推荐基准尺寸：`1080 x 1920`
- 格式：`PNG`
- 背景类默认不透明底
- 构图要为中部主战区留出足够留白

### 21.2 背景交付清单

| 优先级 | 文件名 | 场景 | 尺寸 | 说明 | 风格要求 |
|---|---|---|---|---|---|
| P0 | `bg-home.png` | 首页 | 1080x1920 | 首页主背景 | 半灰半彩的山野世界、中央金色字雨或发光古书、梦幻柔和 |
| P0 | `bg-worldmap.png` | 世界地图 | 1080x1920 | 山野卷轴式地图底图 | 纵向卷轴、云雾分层、章节路径明显、整体低对比 |
| P0 | `bg-mountain-gray.png` | 山野关卡 | 1080x1920 | 山野灰白版背景 | 轻水墨、低饱和、山河未复苏、主战区留白 |
| P0 | `bg-mountain-color.png` | 山野关卡 | 1080x1920 | 山野修复版背景 | 与灰白版同构图，增加青绿山体、淡蓝河流、暖色光感 |
| P1 | `bg-result.png` | 结算页 | 1080x1920 | 结算页背景 | 更安静、更明亮，适合承载卷轴面板 |
| P1 | `bg-calibration.png` | 校准页 | 1080x1920 | 校准引导背景 | 简洁、干净、带轻云纹或淡墨纹理，不干扰摄像头框 |
| P1 | `bg-settings.png` | 设置页 | 1080x1920 | 设置页背景 | 宣纸纹理 + 淡淡山水轮廓，不抢卡片面板 |
| P2 | `bg-collection.png` | 图鉴页 | 1080x1920 | 图鉴背景 | 像翻开的字书或纸张世界，安静干净 |
| P2 | `bg-boss-mountain.png` | BOSS 关 | 1080x1920 | 山野最终关背景 | 比普通关更有高潮感，但仍保持儿童友好和操作留白 |

### 21.3 背景制作要点

- `bg-mountain-gray.png` 与 `bg-mountain-color.png` 必须是同一构图。
- 世界修复表现优先通过颜色、光感和少量生机元素完成，不通过增加复杂物件完成。
- 所有关卡背景中部必须留出汉字与手势轨迹活动区域。
- 地图背景要能承载节点、路径、进度条，不能自己太花。

---

## 二十二、音乐与音效交付物列表

以下为本轮 MVP 建议交付的音乐与音效清单，优先保证首页、地图、关卡、结算四类体验完整。

### 22.1 音频交付原则

- 格式推荐：`MP3`
- BGM 长度建议：`45-90 秒`，可循环
- SFX 长度建议：`0.2-2 秒`
- 所有音频都必须儿童友好、柔和、不惊吓
- 风格统一为“轻国风游戏音频”，不要混入明显西式奇幻或现代电子 UI 音色

### 22.2 BGM 交付清单

| 优先级 | 文件名 | 场景 | 时长建议 | 说明 | 音乐方向 |
|---|---|---|---|---|---|
| P0 | `bgm-home.mp3` | 首页 | 60s | 开场与主菜单音乐 | 梦幻、温暖、像打开古书进入童话山野 |
| P0 | `bgm-worldmap.mp3` | 世界地图 | 60s | 地图推进音乐 | 轻探索、轻节奏、有前进感 |
| P0 | `bgm-mountain.mp3` | 山野关卡 | 60-90s | 山野关卡主 BGM | 轻快、专注、适合切字节奏 |
| P1 | `bgm-result.mp3` | 结算页 | 15-20s | 结算短 BGM | 奖励感、明亮、收束自然 |
| P1 | `bgm-boss.mp3` | BOSS 关 | 45-60s | 山野最终关音乐 | 有高潮但不压迫，儿童友好 |

### 22.3 BGM 制作建议

首页：

- 笛子或箫为主
- 古筝、钟琴做点缀
- 速度中慢
- 像旅程开始

地图：

- 节奏比首页略明显
- 可加入轻木琴或轻打击
- 有探索感，不焦虑

关卡：

- 节奏感要支撑划切操作
- 不能太满，避免压住音效
- 用短拨弦、木琴、笛子做轻律动

结算：

- 短、亮、温暖
- 适合过关后承接奖励反馈

BOSS：

- 比普通关更有推进感
- 可以增加鼓点和旋律张力
- 不要做成战斗史诗感

### 22.4 SFX 交付清单

| 优先级 | 文件名 | 场景 | 时长建议 | 说明 | 声音方向 |
|---|---|---|---|---|---|
| P0 | `sfx-slash-correct.mp3` | 关卡 | 0.3-0.6s | 正确切中字 | 清亮、像切开发光纸片 |
| P0 | `sfx-slash-wrong.mp3` | 关卡 | 0.3-0.5s | 切中错误字 | 轻微、柔和、不刺耳 |
| P0 | `sfx-combo-up.mp3` | 关卡 | 0.5-1s | 连击增长 | 递进上扬、带一点闪光感 |
| P0 | `sfx-level-clear.mp3` | 结算 | 1.5-2.5s | 关卡完成 | 温暖奖励、明确收束 |
| P0 | `sfx-btn-click.mp3` | 全局 UI | 0.2-0.3s | 按钮点击 | 柔软干净，不像系统点击 |
| P1 | `sfx-unlock.mp3` | 地图/解锁 | 1-1.5s | 节点解锁 | 神奇、金光、像文字归位 |
| P1 | `sfx-world-reveal.mp3` | 世界修复 | 1.5-2.5s | 灰到彩变化 | 云雾散开、金线铺开、柔和有仪式感 |
| P1 | `sfx-char-card.mp3` | 结算/图鉴 | 0.5-1s | 字卡翻开或入库 | 纸张、轻亮、收藏感 |
| P1 | `sfx-boss-complete.mp3` | BOSS 关 | 1.5-2s | 最终解封成功 | 稍大但不吓人，像大字被点亮 |

### 22.5 音效制作建议

可以优先参考这些材质感：

- 发光纸片被划开
- 细碎金粉散开
- 轻铃音
- 柔和木质敲击
- 纸张翻开
- 墨迹轻微扩散

不要使用：

- 刀剑劈砍
- 激烈爆炸
- 尖锐报错蜂鸣
- 明显赛博电子音

### 22.6 本轮最小可交付音频包

如果时间非常紧，先保证以下最小集：

- `bgm-home.mp3`
- `bgm-worldmap.mp3`
- `bgm-mountain.mp3`
- `sfx-slash-correct.mp3`
- `sfx-slash-wrong.mp3`
- `sfx-combo-up.mp3`
- `sfx-level-clear.mp3`
- `sfx-btn-click.mp3`

这组足以先支撑首页、地图、关卡、结算的完整体验。

---

## 二十三、开场动画视频提示词与台词说明

本段用于统一游戏开场动画的风格、叙事和台词口径，可交给视频生成、动效设计或分镜制作伙伴直接参考。

### 23.1 开场动画目标

开场动画需要在 `20-35 秒` 内完成 3 件事：

- 交代世界观
- 建立统一风格
- 让玩家理解“用手指让文字归来”

动画的气质必须与本项目统一风格保持一致：

- 东方童话卡通
- 轻水墨背景
- 金色书法能量
- 儿童友好
- 有游戏感而不是说教感

### 23.2 世界背景说明

统一叙事口径如下：

很久以前，这个世界由文字点亮。

- 有了“山”，山才有轮廓
- 有了“水”，河流才会流动
- 有了“木”，草木才会生长

后来，文字的光逐渐熄灭，山河褪成灰白，世界失去了名字，也失去了生机。

玩家将作为“执笔者”，举起手指，在镜头前划开汉字，让失落的文字重新回到世界中。

这个世界不是靠战斗恢复，而是靠“认出字、切中字、让文字归位”恢复。

### 23.3 开场动画统一视觉要求

- 画面比例：竖屏 `9:16`
- 时长建议：`20-35 秒`
- 主背景：灰白山野逐渐被金色文字点亮
- 主特效：金色字雨、墨迹扩散、卷轴展开、云雾散开
- 角色：字灵可以作为引导者出现，但不抢主画面
- 色调变化：从灰白、淡墨，逐步转向暖金、青绿、淡蓝

### 23.4 视频生成统一提示词前缀

所有开场动画视频提示词建议统一包含以下基调：

```text
vertical 9:16 cinematic opening for a child-friendly Chinese fantasy mobile game, eastern fairytale atmosphere, soft ink-wash mountains, gentle mist, warm golden glowing Chinese characters, storybook quality, cute but elegant, light commercial game style, clean composition, magical and healing, not dark, not epic war, not realistic, no horror
```

### 23.5 开场动画总提示词

如果对方使用 AI 视频生成工具，可直接先尝试以下完整提示词：

```text
vertical 9:16 cinematic opening for a child-friendly Chinese fantasy mobile game, eastern fairytale atmosphere, soft ink-wash mountains, gentle mist, warm golden glowing Chinese characters, storybook quality, cute but elegant, light commercial game style, clean composition, magical and healing, not dark, not epic war, not realistic, no horror,
an ancient painted world lies silent in grey and white, mountains have no color, rivers are still, trees are only faint outlines in mist, old parchment texture and drifting clouds, then golden Chinese characters begin to fall from the sky like gentle rain, each character leaves glowing calligraphy trails, when the characters touch the land, the world slowly comes back to life, mountains turn soft green, rivers become pale blue, trees bloom with warm color, a small cute ink spirit appears as a guide, a child raises a finger and draws a glowing golden stroke in the air, slicing through a large floating Chinese character, the character bursts into golden particles and flies into the world, restoring light and life, ending on a bright magical mountain scene with the game title and a sense of adventure beginning
```

### 23.6 分镜版提示词

如果对方更适合按镜头做视频，可以按以下 5 镜制作。

#### 镜头 1：失去文字的世界

时长建议：

- `4-6 秒`

画面内容：

- 灰白山野
- 雾气
- 没有生机的河流与山体
- 像未完成的画卷

视频提示词：

```text
vertical 9:16, a silent ancient Chinese landscape in soft grey ink-wash style, faded mountains, still river, empty trees, drifting mist, parchment texture, magical but lifeless, child-friendly eastern fairytale mood, clean composition, no characters, no text
```

#### 镜头 2：文字从天而降

时长建议：

- `4-6 秒`

画面内容：

- 天空出现微光
- 金色汉字像雨一样缓缓落下
- 带书法拖尾

视频提示词：

```text
vertical 9:16, warm golden Chinese characters begin to fall from the sky like gentle rain, each one glowing softly with calligraphy energy trails, soft clouds parting, magical healing atmosphere, eastern fantasy mobile game opening, child-friendly, elegant and beautiful
```

#### 镜头 3：字灵出现并引导

时长建议：

- `3-5 秒`

画面内容：

- 字灵从光里飞出
- 回头看向玩家
- 轻轻示意“跟我来”

视频提示词：

```text
vertical 9:16, a tiny cute ink spirit made of ink and golden light appears from floating characters, round and adorable, expressive eyes, soft glow, guiding the viewer forward, eastern fairytale game mascot, child-friendly, clean magical composition
```

#### 镜头 4：手指执笔，切开汉字

时长建议：

- `4-6 秒`

画面内容：

- 一根手指在空中划过
- 金色笔锋形成轨迹
- 巨大的汉字被划开
- 金粉与墨迹散开

视频提示词：

```text
vertical 9:16, a child raises one finger and traces a glowing golden calligraphy stroke in the air, the stroke slices through a large floating Chinese character, the character breaks into golden particles, ink and light scatter beautifully, dynamic but gentle, magical gesture control feeling, mobile game cinematic, child-friendly
```

#### 镜头 5：世界复苏与标题出现

时长建议：

- `5-8 秒`

画面内容：

- 山河从灰白变彩色
- 河流亮起，树木恢复色彩
- 远景稳定
- Logo 出现

视频提示词：

```text
vertical 9:16, the painted mountain world comes back to life, grey ink-wash turns into soft green mountains and pale blue river, warm golden light spreads across the land, tiny birds and blossoms appear, the atmosphere becomes hopeful and magical, ending with a clean title reveal for a Chinese character adventure game
```

### 23.7 开场旁白台词建议

如果需要配旁白，建议控制在 `3-5 句`，每句短，节奏温柔，不要像纪录片或广告配音。

推荐版：

1. 很久以前，世界曾被文字点亮。
2. 有了“山”，山才有形。
3. 有了“水”，河流才会流动。
4. 后来，文字失落了，世界也渐渐褪成灰白。
5. 现在，举起你的手指，让文字归来吧。

更儿童向版本：

1. 从前，山河都会说话。
2. 因为每一座山、每一条河，都有属于自己的字。
3. 可是有一天，字的光消失了。
4. 世界变得安安静静，也失去了颜色。
5. 快来用你的手指，把它们找回来吧。

### 23.8 字灵台词建议

如果采用字灵说话口吻，推荐更轻、更像伙伴：

- 这些字睡着了，我们把它们叫醒吧。
- 你切中的每一个字，都会让世界亮一点。
- 看，山的名字回来了。
- 再试一次，这次我们会找到对的字。
- 跟我来，前面还有更多失落的文字。

### 23.9 Logo 出场文案建议

标题出现时可选副文案：

- 举起手指，让文字归来
- 在运动中学汉字，在游戏里修复世界
- 切开汉字，点亮山河

### 23.10 开场音乐建议

开场动画建议直接使用 `bgm-home.mp3` 风格，但前 `8-12 秒` 可以更空灵、更像序章。

音乐节奏建议：

- 开头：轻雾感、弱节拍
- 中段：金色字雨出现时加入铃音与古筝点弦
- 切字瞬间：加入清亮上扬音型
- 结尾标题：稳定在温暖主旋律上
