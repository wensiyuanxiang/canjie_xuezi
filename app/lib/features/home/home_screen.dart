import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/bgm_service.dart';
import '../../core/constants/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/character_record.dart';
import '../../data/models/level_config.dart';
import '../../data/progress/game_progress.dart';
import '../../data/providers/game_data_providers.dart';
import '../../ui/game_action_button.dart';
import 'home_hero_illustration.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bgmServiceProvider).play(BgmTrack.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final WidgetRef ref = this.ref;
    final GameProgressState progress = ref.watch(gameProgressProvider);
    final AsyncValue<List<LevelConfig>> levelsAsync = ref.watch(levelsListProvider);
    final AsyncValue<List<CharacterRecord>> charsAsync =
        ref.watch(charactersListProvider);

    final Widget strip = levelsAsync.when(
      loading: () => const SizedBox(height: 52),
      error: (_, __) => const SizedBox(height: 52),
      data: (List<LevelConfig> levels) {
        return charsAsync.when(
          loading: () => const SizedBox(height: 52),
          error: (_, __) => const SizedBox(height: 52),
          data: (List<CharacterRecord> chars) {
            final List<String> ids = chars.map((CharacterRecord c) => c.id).toList();
            final int learned = ref
                .read(gameProgressProvider.notifier)
                .collectedCount(levels, ids);
            final int repair = progress.repairPercent(levels.length);
            return _KidProgressStrip(
              repairPercent: repair,
              learned: learned,
              total: ids.length,
              loaded: progress.loaded,
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8), // Playful light blue background
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Add some background decorative elements
            Positioned(
              top: -30,
              left: -30,
              child: _buildCloud(width: 120, height: 80, opacity: 0.5),
            ),
            Positioned(
              top: 100,
              right: -40,
              child: _buildCloud(width: 150, height: 100, opacity: 0.4),
            ),
            Positioned(
              bottom: 150,
              left: -20,
              child: _buildCloud(width: 100, height: 60, opacity: 0.6),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D), // Playful orange
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          '仓颉切字',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.white,
                        shape: CircleBorder(
                          side: BorderSide(color: Colors.blue.shade200, width: 3),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => context.push(RoutePaths.settings),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.settings_rounded,
                              color: Colors.blue,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _HeroTitle(),
                  const SizedBox(height: 8),
                  const Text(
                    '举起手指，让文字归来！',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '在运动中学汉字，在游戏里修复世界',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const HomeHeroIllustration(),
                  const SizedBox(height: 16),
                  strip,
                  const SizedBox(height: 24),
                  PrimaryGameButton(
                    label: '开始冒险',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => context.go(RoutePaths.worldMap),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SecondaryGameButton(
                          label: '我的字卡',
                          icon: Icons.star_rounded,
                          onPressed: () => context.push(RoutePaths.collection),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SecondaryGameButton(
                          label: '动作校准',
                          icon: Icons.child_care_rounded,
                          onPressed: () => context.push(RoutePaths.calibration),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud({required double width, required double height, required double opacity}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _KidProgressStrip extends StatelessWidget {
  const _KidProgressStrip({
    required this.repairPercent,
    required this.learned,
    required this.total,
    required this.loaded,
  });

  final int repairPercent;
  final int learned;
  final int total;
  final bool loaded;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const SizedBox(height: 52);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 3,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.park_rounded, color: AppColors.success, size: 24),
              ),
              const SizedBox(width: 10),
              const Text(
                '世界修复进度',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF424242),
                ),
              ),
              const Spacer(),
              Text(
                '$repairPercent%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDeep,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: repairPercent / 100,
              minHeight: 14,
              backgroundColor: const Color(0xFFEEEEEE),
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF8E1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 10),
              const Text(
                '已收集汉字精灵',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF616161),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$learned / $total',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Glowing/Shadow outline
          Text(
            '仓颉切字',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontFamily: 'ZhiMangXing',
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.white.withValues(alpha: 0.9),
            ),
          ),
          // Gradient fill suitable for kids
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFFFF9A9E), // soft rosy
                  Color(0xFFFECFEF), // pale pink
                  Color(0xFFFCCB90), // pastel orange
                ],
              ).createShader(bounds);
            },
            child: const Text(
              '仓颉切字',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

