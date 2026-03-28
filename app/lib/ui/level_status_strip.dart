import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../game/slice_hud_snapshot.dart';

/// 关卡顶栏内嵌的紧凑状态（单行小字 + 分隔点）。
class LevelHudStatusInline extends StatelessWidget {
  const LevelHudStatusInline({super.key, required this.snapshot});

  final SliceHudSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.ended) {
      return const SizedBox.shrink();
    }
    final int sec = snapshot.timeLeft.ceil().clamp(0, 9999);
    final TextStyle base = Theme.of(context).textTheme.labelSmall!.copyWith(
          color: AppColors.inkMuted,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          height: 1,
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.timer_outlined, size: 13, color: AppColors.primaryDeep),
        const SizedBox(width: 3),
        Text('$sec', style: base.copyWith(color: AppColors.ink)),
        Text(' · ', style: base),
        Icon(Icons.gps_fixed_rounded, size: 12, color: AppColors.success),
        const SizedBox(width: 2),
        Text(
          '${snapshot.correct}/${snapshot.quota}',
          style: base.copyWith(color: AppColors.success),
        ),
        Text(' · ', style: base),
        Icon(Icons.bolt_rounded, size: 12, color: AppColors.goldDim),
        const SizedBox(width: 2),
        Text('${snapshot.combo}', style: base),
        if (snapshot.wrong > 0) ...<Widget>[
          Text(' · ', style: base),
          Text('误${snapshot.wrong}', style: base),
        ],
        if (snapshot.missed > 0) ...<Widget>[
          Text(' · ', style: base),
          Text('漏${snapshot.missed}', style: base),
        ],
      ],
    );
  }
}
