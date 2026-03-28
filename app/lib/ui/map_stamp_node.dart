import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class MapStampNode extends StatefulWidget {
  const MapStampNode({
    super.key,
    required this.indexLabel,
    required this.title,
    required this.mapPosition,
    required this.mapTeaser,
    required this.kidHint,
    required this.isBoss,
    required this.isLocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.onTap,
  });

  final String indexLabel;
  final String title;
  final String mapPosition;
  final String mapTeaser;
  final String kidHint;
  final bool isBoss;
  final bool isLocked;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  State<MapStampNode> createState() => _MapStampNodeState();
}

class _MapStampNodeState extends State<MapStampNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isCurrent && !widget.isLocked) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(MapStampNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool shouldPulse = widget.isCurrent && !widget.isLocked;
    final bool wasPulse = oldWidget.isCurrent && !oldWidget.isLocked;
    if (shouldPulse && !wasPulse) {
      _pulse.repeat(reverse: true);
    } else if (!shouldPulse && wasPulse) {
      _pulse.stop();
      _pulse.reset();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double diameter = widget.isBoss ? 92 : 76;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isLocked
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('先通关上一关，这里就会解锁啦！'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            : widget.onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedBuilder(
                animation: _pulse,
                builder: (BuildContext context, Widget? child) {
                  final double scale =
                      widget.isCurrent && !widget.isLocked ? 1.0 + _pulse.value * 0.06 : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: _StampSeal(
                  diameter: diameter,
                  label: widget.indexLabel,
                  isBoss: widget.isBoss,
                  isLocked: widget.isLocked,
                  isCompleted: widget.isCompleted,
                  isCurrent: widget.isCurrent,
                ),
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
                            widget.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: widget.isBoss ? 17 : 16,
                                  color: widget.isLocked
                                      ? AppColors.grayBlue
                                      : AppColors.ink,
                                ),
                          ),
                        ),
                        if (widget.isCompleted)
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.gold,
                            size: 22,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.mapPosition,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDeep,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.mapTeaser,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                            color: AppColors.success.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.kidHint,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    height: 1.35,
                                    color: AppColors.inkMuted,
                                  ),
                            ),
                          ),
                        ],
                      ),
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

class _StampSeal extends StatelessWidget {
  const _StampSeal({
    required this.diameter,
    required this.label,
    required this.isBoss,
    required this.isLocked,
    required this.isCompleted,
    required this.isCurrent,
  });

  final double diameter;
  final String label;
  final bool isBoss;
  final bool isLocked;
  final bool isCompleted;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isLocked
        ? AppColors.grayBlue.withValues(alpha: 0.45)
        : isCurrent
            ? AppColors.primary
            : isBoss
                ? AppColors.gold
                : AppColors.gold.withValues(alpha: 0.55);
    final double borderWidth = isCurrent ? 3.2 : (isBoss ? 3 : 2.5);

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLocked
              ? <Color>[
                  AppColors.grayBlue.withValues(alpha: 0.12),
                  AppColors.grayBlue.withValues(alpha: 0.2),
                ]
              : isBoss
                  ? <Color>[
                      AppColors.parchment,
                      AppColors.gold.withValues(alpha: 0.35),
                    ]
                  : <Color>[
                      AppColors.parchment,
                      AppColors.parchmentDeep,
                    ],
        ),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: <BoxShadow>[
          if (isCurrent && !isLocked)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.1),
            blurRadius: isBoss ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: isLocked
          ? Icon(Icons.lock_rounded, color: AppColors.grayBlue, size: 28)
          : isCompleted
              ? Icon(Icons.check_rounded, color: AppColors.success, size: 32)
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isBoss ? 14 : 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: isBoss ? 1.0 : 0.4,
                    height: 1.1,
                  ),
                ),
    );
  }
}

class MapPathConnector extends StatelessWidget {
  const MapPathConnector({super.key, this.dim = false});

  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 38),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.gold.withValues(alpha: dim ? 0.08 : 0.15),
                AppColors.gold.withValues(alpha: dim ? 0.25 : 0.55),
                AppColors.gold.withValues(alpha: dim ? 0.08 : 0.15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
