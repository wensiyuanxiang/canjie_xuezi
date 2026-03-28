import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../game/slice_hud_snapshot.dart';
import 'level_status_strip.dart';

/// 单行横条顶栏：不占大块方块区域。
class LevelHudBar extends StatelessWidget {
  const LevelHudBar({
    super.key,
    required this.title,
    required this.missionPhrase,
    required this.targetGlyph,
    required this.onExit,
    required this.onFinishPlaceholder,
    required this.status,
    this.spiritCompact,
  });

  final String title;
  final String missionPhrase;
  final String targetGlyph;
  final VoidCallback onExit;
  final VoidCallback onFinishPlaceholder;
  final SliceHudSnapshot status;
  final Widget? spiritCompact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.hudBar.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.45),
            width: 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _HudIconButton(
                icon: Icons.close_rounded,
                onPressed: onExit,
                color: const Color(0xFFE53935),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.ink,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    height: 1.1,
                                  ),
                        ),
                      ),
                      if (spiritCompact != null) ...<Widget>[
                        const SizedBox(width: 6),
                        spiritCompact!,
                      ],
                      const SizedBox(width: 8),
                      Tooltip(
                        message: missionPhrase,
                        triggerMode: TooltipTriggerMode.longPress,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDeep,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            targetGlyph,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      if (!status.ended) ...<Widget>[
                        const SizedBox(width: 10),
                        LevelHudStatusInline(snapshot: status),
                      ],
                    ],
                  ),
                ),
              ),
              _HudIconButton(
                icon: Icons.fast_forward_rounded,
                onPressed: onFinishPlaceholder,
                color: AppColors.success,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudIconButton extends StatelessWidget {
  const _HudIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
