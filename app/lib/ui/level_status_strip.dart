import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../game/slice_hud_snapshot.dart';

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
          _chip(context, Icons.timer_outlined, '$sec 秒', const Color(0xFFFF5252)),
          _chip(
            context,
            Icons.gps_fixed_rounded,
            '目标 ${snapshot.correct}/${snapshot.quota}',
            const Color(0xFF4CAF50),
          ),
          _chip(
            context,
            Icons.bolt_rounded,
            '连击 x${snapshot.combo}',
            const Color(0xFFFFC107),
          ),
          _chip(
            context,
            Icons.blur_off_rounded,
            '误切 ${snapshot.wrong}',
            const Color(0xFF78909C),
          ),
          _chip(
            context,
            Icons.vertical_align_top_rounded,
            '漏 ${snapshot.missed}',
            const Color(0xFFFF9800),
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
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.5), width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: accent.withValues(alpha: 0.9),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
