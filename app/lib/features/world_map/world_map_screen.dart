import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/character_record.dart';
import '../../data/models/level_config.dart';
import '../../data/progress/game_progress.dart';
import '../../data/providers/game_data_providers.dart';
import '../../ui/game_loading.dart';
import '../../ui/game_nav_bar.dart';
import '../../ui/map_stamp_node.dart';
import '../../ui/parchment_card.dart';
import '../../ui/xuan_paper_background.dart';

class WorldMapScreen extends ConsumerWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LevelConfig>> levelsAsync = ref.watch(levelsListProvider);
    final AsyncValue<List<CharacterRecord>> charsAsync =
        ref.watch(charactersListProvider);
    final GameProgressState progress = ref.watch(gameProgressProvider);
    final GameProgressNotifier progressNotifier =
        ref.read(gameProgressProvider.notifier);

    return Scaffold(
      body: XuanPaperBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GameNavBar(
                title: '山野',
                onBack: () => context.go(RoutePaths.home),
                trailing: Material(
                  color: AppColors.hudBar,
                  shape: const CircleBorder(
                    side: BorderSide(color: AppColors.gold, width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    onPressed: () => context.push(RoutePaths.settings),
                    icon: const Icon(Icons.tune_rounded),
                    color: AppColors.ink,
                    iconSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: levelsAsync.when(
                  data: (List<LevelConfig> levels) {
                    return charsAsync.when(
                      data: (List<CharacterRecord> chars) {
                        final List<String> charIds =
                            chars.map((CharacterRecord c) => c.id).toList();
                        final int learned = progressNotifier.collectedCount(
                          levels,
                          charIds,
                        );
                        final int repair = progress.repairPercent(levels.length);
                        final int? currentIdx =
                            progressNotifier.currentLevelIndex(levels);

                        return Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              child: _MapProgressHeader(
                                repairPercent: repair,
                                learned: learned,
                                totalChars: charIds.length,
                                loaded: progress.loaded,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: ParchmentCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      const ParchmentSectionTitle(
                                        text: '卷一 · 山野官卡',
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '每一关都会让山河更清楚一点，跟着提示去找目标字吧！',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 18),
                                      for (int i = 0; i < levels.length; i++) ...<Widget>[
                                        if (i > 0)
                                          MapPathConnector(
                                            dim: !progressNotifier
                                                .isLevelCompleted(
                                              levels[i - 1].id,
                                            ),
                                          ),
                                        MapStampNode(
                                          indexLabel: _nodeLabel(levels[i]),
                                          title: levels[i].title,
                                          mapPosition: levels[i].mapPosition,
                                          mapTeaser: levels[i].mapTeaser,
                                          kidHint: levels[i].kidHint,
                                          isBoss: levels[i].isBoss,
                                          isLocked: !progressNotifier
                                              .isLevelUnlocked(levels, i),
                                          isCompleted: progressNotifier
                                              .isLevelCompleted(levels[i].id),
                                          isCurrent: currentIdx == i,
                                          onTap: () => context.push(
                                            '${RoutePaths.level}/${levels[i].id}',
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          context.go(RoutePaths.home),
                                      icon: const Icon(Icons.home_rounded),
                                      label: const Text('回首页'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () => context
                                          .push(RoutePaths.collection),
                                      icon: const Icon(
                                        Icons.collections_bookmark_rounded,
                                      ),
                                      label: const Text('字卡'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const GameLoadingCenter(),
                      error: (Object err, StackTrace _) => Center(
                        child: Text('角色数据错误：$err'),
                      ),
                    );
                  },
                  loading: () => const GameLoadingCenter(),
                  error: (Object err, StackTrace _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ParchmentCard(
                        child: Text(
                          '加载关卡失败：$err',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
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

class _MapProgressHeader extends StatelessWidget {
  const _MapProgressHeader({
    required this.repairPercent,
    required this.learned,
    required this.totalChars,
    required this.loaded,
  });

  final int repairPercent;
  final int learned;
  final int totalChars;
  final bool loaded;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const SizedBox(height: 8);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.parchment.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '山野修复',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              Text(
                '$repairPercent%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDeep,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: repairPercent / 100,
              minHeight: 8,
              backgroundColor: AppColors.bgWarm,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '已学汉字 $learned / $totalChars',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

String _nodeLabel(LevelConfig level) {
  if (level.isBoss) {
    return 'BOSS';
  }
  return '${level.order}';
}
