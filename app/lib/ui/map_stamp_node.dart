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
    this.lockedSnackMessage,
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

  /// 锁定态点按时提示；为 null 时使用「先通关上一关…」。
  final String? lockedSnackMessage;

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
      duration: const Duration(milliseconds: 1000),
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
    final double diameter = widget.isBoss ? 80 : 64;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isLocked
            ? () {
                final String msg = widget.lockedSnackMessage ??
                    '先通关上一关，这里就会解锁啦！';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      msg,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.orange.shade400,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }
            : widget.onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedBuilder(
                animation: _pulse,
                builder: (BuildContext context, Widget? child) {
                  final double scale =
                      widget.isCurrent && !widget.isLocked ? 1.0 + _pulse.value * 0.1 : 1.0;
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
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.isCurrent
                          ? const Color(0xFFFFB74D) // Orange for current
                          : const Color(0xFFEEEEEE),
                      width: widget.isCurrent ? 3 : 2,
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: widget.isBoss ? 18 : 16,
                                fontWeight: FontWeight.w900,
                                color: widget.isLocked
                                    ? Colors.grey.shade400
                                    : const Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                          if (widget.isCompleted)
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC107),
                              size: 28,
                            ),
                          if (widget.isLocked)
                            Icon(
                              Icons.lock_rounded,
                              color: Colors.grey.shade300,
                              size: 24,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.mapPosition,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDeep,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.mapTeaser,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1), // Light yellow hint box
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(
                              Icons.lightbulb_rounded,
                              size: 20,
                              color: Color(0xFFFFB300),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.kidHint,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                  color: Color(0xFF6D4C41),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    // Generate lovely gradient colors for bubbles
    late final List<Color> gradientColors;
    late final Color strokeColor;

    if (isLocked) {
      gradientColors = <Color>[Colors.grey.shade200, Colors.grey.shade300];
      strokeColor = Colors.grey.shade400;
    } else if (isCompleted) {
      gradientColors = <Color>[const Color(0xFFA5D6A7), const Color(0xFF66BB6A)];
      strokeColor = const Color(0xFF43A047);
    } else if (isCurrent) {
      gradientColors = <Color>[const Color(0xFFFFCC80), const Color(0xFFFFA726)];
      strokeColor = const Color(0xFFFB8C00);
    } else if (isBoss) {
      gradientColors = <Color>[const Color(0xFFCE93D8), const Color(0xFFAB47BC)];
      strokeColor = const Color(0xFF8E24AA);
    } else {
      gradientColors = <Color>[const Color(0xFF90CAF9), const Color(0xFF42A5F5)];
      strokeColor = const Color(0xFF1E88E5);
    }

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: strokeColor.withValues(alpha: 0.5),
            blurRadius: 0,
            offset: const Offset(0, 4), // Solid offset for 3D bubbly look
          ),
          if (isCurrent)
            BoxShadow(
              color: strokeColor.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      alignment: Alignment.center,
      child: isLocked
          ? const Icon(Icons.lock_rounded, color: Colors.white, size: 28)
          : isCompleted
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 36)
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isBoss ? 16 : 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
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
      padding: const EdgeInsets.only(left: 36, top: 4, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 8,
          height: 24,
          decoration: BoxDecoration(
            color: dim ? Colors.grey.shade300 : const Color(0xFFFFB74D), // Sunny orange path
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
