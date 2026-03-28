import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';
import '../../data/models/level_config.dart';
import '../../data/models/level_result.dart';
import '../../data/progress/game_progress.dart';
import '../../data/providers/game_data_providers.dart';
import '../level/level_screen.dart';
import '../../ui/game_action_button.dart';
import '../../ui/parchment_card.dart';

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
      backgroundColor: const Color(0xFFF0F8FF), // Playful sky blue
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2C3E50), size: 28),
                      onPressed: () => context.go(RoutePaths.worldMap),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '本局小结',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // balance the back button
                ],
              ),
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
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE0B2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFFB74D),
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  widget.result.levelId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                    color: Color(0xFFE65100),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                widget.result.levelCleared ? Icons.star_rounded : Icons.extension_rounded,
                                color: widget.result.levelCleared ? const Color(0xFFFFC107) : const Color(0xFF64B5F6),
                                size: 36,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.result.levelCleared
                                ? '🎉 你修复了世界的一角！'
                                : '💦 时间到啦，再试一次会更好哦！',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2C3E50),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          levelAsync.when(
                            data: (LevelConfig? cfg) {
                              if (cfg == null ||
                                  !widget.result.levelCleared) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF81C784),
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  cfg.repairStory,
                                  style: const TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontSize: 16,
                                    height: 1.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              );
                            },
                            loading: () => const SizedBox(height: 8),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            '🌟 游戏表现 🌟',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9C4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.record_voice_over_rounded,
                                  size: 24,
                                  color: Color(0xFFF57F17),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '读音与 AI 小故事将在这里播放...',
                                    style: TextStyle(
                                      color: Color(0xFFF57F17),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                              const SizedBox(height: 12),
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
    );
  }
}
