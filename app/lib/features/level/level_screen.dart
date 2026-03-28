import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/level_config.dart';
import '../../data/models/level_result.dart';
import '../../data/repositories/game_content_repository.dart';
import '../../game/slice_hud_snapshot.dart';
import '../../game/zaozi_slice_game.dart';
import '../../ui/game_loading.dart';
import '../../ui/level_hud_bar.dart';
import '../../ui/parchment_card.dart';
import '../../ui/xuan_paper_background.dart';

final levelByIdProvider =
    FutureProvider.autoDispose.family<LevelConfig?, String>(
  (Ref ref, String id) =>
      ref.read(gameContentRepositoryProvider).levelById(id),
);

class LevelScreen extends ConsumerStatefulWidget {
  const LevelScreen({super.key, required this.levelId});

  final String levelId;

  @override
  ConsumerState<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends ConsumerState<LevelScreen> {
  ZaoziSliceGame? _game;
  String? _boundLevelId;

  bool _spiritExpanded = true;
  String? _spiritScheduledForLevelId;
  Timer? _spiritCollapseTimer;

  @override
  void dispose() {
    _spiritCollapseTimer?.cancel();
    super.dispose();
  }

  void _bindGame(LevelConfig config) {
    if (_boundLevelId != config.id) {
      _boundLevelId = config.id;
      _spiritCollapseTimer?.cancel();
      _game = ZaoziSliceGame(
        levelConfig: config,
        onSessionEnd: _pushResult,
      );
      _spiritExpanded = true;
      _spiritScheduledForLevelId = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _boundLevelId != config.id) {
          return;
        }
        _scheduleSpiritCollapse(config.id);
      });
    }
  }

  void _scheduleSpiritCollapse(String levelId, {bool force = false}) {
    if (!force && _spiritScheduledForLevelId == levelId) {
      return;
    }
    _spiritScheduledForLevelId = levelId;
    _spiritCollapseTimer?.cancel();
    _spiritCollapseTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) {
        return;
      }
      setState(() => _spiritExpanded = false);
    });
  }

  void _pushResult(LevelResult result) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.push(RoutePaths.result, extra: result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<LevelConfig?> levelAsync =
        ref.watch(levelByIdProvider(widget.levelId));

    return Scaffold(
      body: levelAsync.when(
        data: (LevelConfig? config) {
          if (config == null) {
            return XuanPaperBackground(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ParchmentCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.travel_explore_rounded,
                            size: 48,
                            color: AppColors.grayBlue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '未找到该关卡',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () => context.go(RoutePaths.worldMap),
                            child: const Text('返回地图'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          _bindGame(config);
          final ZaoziSliceGame game = _game!;

          final Widget? spiritChip = !_spiritExpanded
              ? Material(
                  color: AppColors.gold.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      setState(() => _spiritExpanded = true);
                      _scheduleSpiritCollapse(config.id, force: true);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.pets_rounded,
                            size: 16,
                            color: AppColors.primaryDeep,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '字灵',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GameWidget(
                key: ValueKey<String>(config.id),
                game: game,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ValueListenableBuilder<SliceHudSnapshot>(
                    valueListenable: game.hudListenable,
                    builder: (
                      BuildContext context,
                      SliceHudSnapshot snap,
                      _,
                    ) {
                      return LevelHudBar(
                        title: config.title,
                        missionPhrase: config.missionPhrase,
                        targetGlyph: config.targetGlyph,
                        onExit: () => context.go(RoutePaths.worldMap),
                        onFinishPlaceholder: () => game.exitToResultManually(),
                        spiritCompact: spiritChip,
                        status: snap,
                      );
                    },
                  ),
                ),
              ),
              if (_spiritExpanded)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: _LevelSpiritHintBar(
                        text: config.kidHint,
                        onCollapse: () {
                          _spiritCollapseTimer?.cancel();
                          setState(() => _spiritExpanded = false);
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const XuanPaperBackground(child: GameLoadingCenter()),
        error: (Object err, StackTrace _) => XuanPaperBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ParchmentCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '加载关卡失败：$err',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go(RoutePaths.worldMap),
                        child: const Text('返回地图'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelSpiritHintBar extends StatelessWidget {
  const _LevelSpiritHintBar({
    required this.text,
    required this.onCollapse,
  });

  final String text;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.pets_rounded,
              color: AppColors.gold.withValues(alpha: 0.95),
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '字灵悄悄说',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.parchment.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.parchment.withValues(alpha: 0.92),
                          fontSize: 13,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCollapse,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              icon: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: AppColors.parchment.withValues(alpha: 0.85),
              ),
              tooltip: '收起提示',
            ),
          ],
        ),
      ),
    );
  }
}
