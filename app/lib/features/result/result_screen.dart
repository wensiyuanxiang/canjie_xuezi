import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/level_config.dart';
import '../../data/models/level_result.dart';
import '../../data/progress/game_progress.dart';
import '../../data/providers/game_data_providers.dart';
import '../level/level_screen.dart';
import '../../ui/game_action_button.dart';
import '../../ui/game_nav_bar.dart';
import '../../ui/parchment_card.dart';
import '../../ui/xuan_paper_background.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, required this.result});

  final LevelResult result;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.result.levelCleared) {
        return;
      }
      ref
          .read(gameProgressProvider.notifier)
          .markLevelCleared(widget.result.levelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<LevelConfig?> levelAsync =
        ref.watch(levelByIdProvider(widget.result.levelId));
    final AsyncValue<List<LevelConfig>> levelsAsync =
        ref.watch(levelsListProvider);

    return Scaffold(
      body: XuanPaperBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GameNavBar(
                title: '本局小结',
                onBack: () => context.go(RoutePaths.worldMap),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ParchmentCard(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.gold
                                          .withValues(alpha: 0.45),
                                    ),
                                  ),
                                  child: Text(
                                    widget.result.levelId,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.goldDim,
                                  size: 26,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.result.levelCleared
                                  ? '你修复了世界的一角'
                                  : '时间到啦，再试一次会更好哦',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 22),
                            ),
                            const SizedBox(height: 10),
                            levelAsync.when(
                              data: (LevelConfig? cfg) {
                                if (cfg == null ||
                                    !widget.result.levelCleared) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.success
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.success
                                          .withValues(alpha: 0.25),
                                    ),
                                  ),
                                  child: Text(
                                    cfg.repairStory,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          height: 1.45,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                );
                              },
                              loading: () => const SizedBox(height: 8),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '战报',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            GameStatTile(
                              icon: Icons.check_circle_rounded,
                              label: '切对',
                              value: '${widget.result.correctCount}',
                            ),
                            GameStatTile(
                              icon: Icons.remove_circle_outline_rounded,
                              label: '漏切',
                              value: '${widget.result.missedCount}',
                            ),
                            GameStatTile(
                              icon: Icons.blur_off_rounded,
                              label: '误切',
                              value: '${widget.result.wrongSlashCount}',
                            ),
                            GameStatTile(
                              icon: Icons.bolt_rounded,
                              label: '最高连击',
                              value: '${widget.result.maxCombo}',
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.grayBlue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.record_voice_over_rounded,
                                    size: 20,
                                    color: AppColors.grayBlue,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '读音与 AI 小故事将在这里播放（单次调用 + 本地回退）。',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      levelsAsync.when(
                        data: (List<LevelConfig> levels) {
                          final int idx = levels
                              .indexWhere((LevelConfig l) =>
                                  l.id == widget.result.levelId);
                          final bool hasNext =
                              idx >= 0 && idx < levels.length - 1;
                          final String? nextId = hasNext
                              ? levels[idx + 1].id
                              : null;
                          final bool showNext =
                              nextId != null && widget.result.levelCleared;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              if (showNext) ...<Widget>[
                                PrimaryGameButton(
                                  label: '下一关',
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: () => context.go(
                                    '${RoutePaths.level}/$nextId',
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                              SecondaryGameButton(
                                label: '返回地图',
                                icon: Icons.map_rounded,
                                onPressed: () =>
                                    context.go(RoutePaths.worldMap),
                              ),
                            ],
                          );
                        },
                        loading: () => PrimaryGameButton(
                          label: '返回地图',
                          icon: Icons.map_rounded,
                          onPressed: () => context.go(RoutePaths.worldMap),
                        ),
                        error: (_, __) => PrimaryGameButton(
                          label: '返回地图',
                          icon: Icons.map_rounded,
                          onPressed: () => context.go(RoutePaths.worldMap),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
