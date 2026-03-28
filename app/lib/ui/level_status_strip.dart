import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../game/slice_hud_snapshot.dart';

/// 关卡内实时状态（时间、目标、连击、误切、漏字），嵌入 [LevelHudBar] 使用。
class LevelHudStatusChips extends StatelessWidget {
  const LevelHudStatusChips({super.key, required this.snapshot});

  final SliceHudSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.ended) {
      return const SizedBox.shrink();
    }
    final int sec = snapshot.timeLeft.ceil().clamp(0, 9999);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _chip(context, Icons.timer_outlined, '$sec 秒', AppColors.parchment),
          _chip(
            context,
            Icons.gps_fixed_rounded,
            '目标 ${snapshot.correct}/${snapshot.quota}',
            AppColors.success,
          ),
          _chip(
            context,
            Icons.bolt_rounded,
            '连击 x${snapshot.combo}',
            AppColors.gold,
          ),
          _chip(
            context,
            Icons.blur_off_rounded,
            '误切 ${snapshot.wrong}',
            AppColors.grayBlue,
          ),
          _chip(
            context,
            Icons.vertical_align_top_rounded,
            '漏 ${snapshot.missed}',
            AppColors.primaryDeep,
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    IconData icon,
    String text,
    Color accent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.parchment.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}
