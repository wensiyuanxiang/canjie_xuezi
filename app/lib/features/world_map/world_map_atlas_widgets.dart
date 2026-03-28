import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/world_atlas.dart';
import '../../ui/parchment_card.dart';

class AtlasPageDots extends StatelessWidget {
  const AtlasPageDots({
    super.key,
    required this.count,
    required this.index,
    required this.onSelect,
  });

  final int count;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < count; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 6),
            GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: i == index ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i == index
                      ? AppColors.primaryDeep
                      : AppColors.gold.withValues(alpha: 0.35),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AtlasWorldBanner extends StatelessWidget {
  const AtlasWorldBanner({
    super.key,
    required this.region,
  });

  final WorldAtlasRegion region;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.parchment.withValues(alpha: 0.95),
            AppColors.bgWarm.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.hudBar,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: Icon(region.icon, color: AppColors.primaryDeep, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        region.volumeTitle,
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (region.isPlayable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          '开放中',
                          style: text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDeep,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.ink.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          '预告',
                          style: text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  region.themeLabel,
                  style: text.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  region.teaser,
                  style: text.bodySmall?.copyWith(
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LockedAtlasRoadmap extends StatelessWidget {
  const LockedAtlasRoadmap({super.key, required this.region});

  final WorldAtlasRegion region;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return ParchmentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ParchmentSectionTitle(text: '${region.title} · 路线图预览'),
          const SizedBox(height: 8),
          Text(
            region.roadmapBlurb,
            style: text.bodySmall?.copyWith(
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.ink.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < 6; i++) ...<Widget>[
                  _LockedRoadStop(
                    label: '${i + 1}',
                    isBoss: false,
                  ),
                  if (i < 5) _RoadArrow(),
                ],
                _RoadArrow(),
                _LockedRoadStop(
                  label: 'BOSS',
                  isBoss: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '八大世界与三纪天象正在陆续实装。当前可在山野关卡修炼笔锋，解救第一卷山河。',
            style: text.bodySmall?.copyWith(
              height: 1.35,
              color: AppColors.ink.withValues(alpha: 0.62),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 18,
        color: AppColors.gold.withValues(alpha: 0.55),
      ),
    );
  }
}

class _LockedRoadStop extends StatelessWidget {
  const _LockedRoadStop({
    required this.label,
    required this.isBoss,
  });

  final String label;
  final bool isBoss;

  @override
  Widget build(BuildContext context) {
    final double d = isBoss ? 56 : 48;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: d,
          height: d,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgWarm,
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_rounded,
            size: isBoss ? 22 : 18,
            color: AppColors.ink.withValues(alpha: 0.35),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.ink.withValues(alpha: 0.5),
              ),
        ),
      ],
    );
  }
}
