# 仓颉切字（Flutter）

竖屏优先；外层 UI 用 Flutter Widget，关卡内玩法用 **Flame**（`GameWidget` 嵌入页面）。

## 运行

```bash
cd app
flutter run
```

## 目录结构（架构）

| 路径 | 职责 |
|------|------|
| `lib/main.dart` | 入口、`ProviderScope`、锁定竖屏 |
| `lib/app.dart` | `MaterialApp.router`、主题 |
| `lib/core/router/` | `go_router` 路由表 |
| `lib/core/theme/` | 规约色板与 `ThemeData` |
| `lib/core/constants/` | 路由路径、资源常量 |
| `lib/data/` | JSON 模型、`LocalJsonBundle`、`GameContentRepository` |
| `lib/features/*/` | 首页、地图、关卡、结算、设置、校准（占位） |
| `lib/game/` | `FlameGame` 子类（切字玩法后续在此扩展） |
| `lib/ui/` | 手游风通用 UI：宣纸底、卷轴卡片、主/次按钮、地图印章节点、关卡 HUD |
| `assets/data/` | `characters.json`、`levels.json`（山野 level-1～level-6-boss） |
| `assets/images/{bg,character,game,particle,ui,rank}/` | 与产品规约分层一致 |
| `assets/audio/{bgm,sfx}/`、`assets/fonts/` | 音频与字体占位 |

## 依赖要点

- `flutter_riverpod`：全局与按特性状态
- `go_router`：声明式路由
- `flame`：关卡画布与组件系统
- `shared_preferences`：存档（后续接进度解锁）
