import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../ui/game_action_button.dart';
import '../../ui/game_nav_bar.dart';
import '../../ui/parchment_card.dart';
import '../../ui/xuan_paper_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: XuanPaperBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GameNavBar(
                title: '设置',
                onBack: () => context.pop(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: <Widget>[
                    ParchmentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const _SettingsRowHeader(),
                          _SettingsTile(
                            icon: Icons.collections_bookmark_rounded,
                            title: '我的字卡',
                            subtitle: '看看已经收集的汉字',
                            onTap: () => context.push(RoutePaths.collection),
                          ),
                          const Divider(height: 24),
                          _SettingsTile(
                            icon: Icons.videocam_rounded,
                            title: '摄像头校准',
                            subtitle: '食指追踪 · 与触屏共用划痕数据',
                            onTap: () => context.push(RoutePaths.calibration),
                          ),
                          const Divider(height: 24),
                          _SettingsTile(
                            icon: Icons.volume_up_rounded,
                            title: '音效与音乐',
                            subtitle: '后续接入开关与音量',
                            onTap: () {},
                          ),
                          const Divider(height: 24),
                          _SettingsTile(
                            icon: Icons.help_outline_rounded,
                            title: '玩法说明',
                            subtitle: '切对目标字，放过干扰字',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SecondaryGameButton(
                      label: '打开字卡',
                      icon: Icons.menu_book_rounded,
                      onPressed: () => context.push(RoutePaths.collection),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsRowHeader extends StatelessWidget {
  const _SettingsRowHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '游戏',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.grayBlue,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.bg.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(icon, color: AppColors.goldDim),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.grayBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
