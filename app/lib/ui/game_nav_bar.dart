import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class GameNavBar extends StatelessWidget {
  const GameNavBar({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
      child: Row(
        children: <Widget>[
          if (onBack != null)
            _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: onBack!,
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    letterSpacing: 1.2,
                    shadows: <Shadow>[
                      Shadow(
                        color: AppColors.parchment.withValues(alpha: 0.9),
                        blurRadius: 8,
                      ),
                    ],
                  ),
            ),
          ),
          SizedBox(
            width: 48,
            child: trailing != null
                ? Align(alignment: Alignment.centerRight, child: trailing!)
                : null,
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.hudBar,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.gold, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 18, color: AppColors.ink),
        ),
      ),
    );
  }
}
