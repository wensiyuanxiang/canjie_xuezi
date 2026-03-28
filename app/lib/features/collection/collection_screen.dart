import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/character_record.dart';
import '../../data/models/level_config.dart';
import '../../data/progress/game_progress.dart';
import '../../data/providers/game_data_providers.dart';
import '../../ui/game_loading.dart';
import '../../ui/game_nav_bar.dart';
import '../../ui/parchment_card.dart';
import '../../ui/xuan_paper_background.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CharacterRecord>> charsAsync =
        ref.watch(charactersListProvider);
    final AsyncValue<List<LevelConfig>> levelsAsync = ref.watch(levelsListProvider);
    final GameProgressNotifier progress = ref.read(gameProgressProvider.notifier);

    return Scaffold(
      body: XuanPaperBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GameNavBar(
                title: '我的字卡',
                onBack: () => context.pop(),
              ),
              Expanded(
                child: charsAsync.when(
                  data: (List<CharacterRecord> chars) {
                    return levelsAsync.when(
                      data: (List<LevelConfig> levels) {
                        final int learned = progress.collectedCount(
                          levels,
                          chars.map((CharacterRecord c) => c.id).toList(),
                        );
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ParchmentCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '收集进度',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '$learned / ${chars.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.primaryDeep,
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.82,
                                ),
                                itemCount: chars.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final CharacterRecord c = chars[index];
                                  final bool got = progress.isCharacterCollected(
                                    c.id,
                                    levels,
                                  );
                                  return _CharTile(character: c, collected: got);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const GameLoadingCenter(),
                      error: (Object e, _) => Center(child: Text('$e')),
                    );
                  },
                  loading: () => const GameLoadingCenter(),
                  error: (Object e, _) => Center(child: Text('$e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CharTile extends StatelessWidget {
  const _CharTile({required this.character, required this.collected});

  final CharacterRecord character;
  final bool collected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: collected
              ? <Color>[
                  AppColors.parchment,
                  AppColors.gold.withValues(alpha: 0.2),
                ]
              : <Color>[
                  AppColors.grayBlue.withValues(alpha: 0.12),
                  AppColors.grayBlue.withValues(alpha: 0.06),
                ],
        ),
        border: Border.all(
          color: collected
              ? AppColors.gold.withValues(alpha: 0.55)
              : AppColors.grayBlue.withValues(alpha: 0.25),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (BuildContext ctx) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      character.glyph,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      character.pinyin,
                      textAlign: TextAlign.center,
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      collected ? '已在本篇官卡中收集' : '通关对应官卡后点亮',
                      textAlign: TextAlign.center,
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  character.glyph,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: collected ? AppColors.ink : AppColors.grayBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  character.pinyin,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                ),
                if (!collected)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: AppColors.grayBlue.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
