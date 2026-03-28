import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class XuanPaperBackground extends StatelessWidget {
  const XuanPaperBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.bgMist,
                AppColors.bg,
                AppColors.bgWarm,
              ],
            ),
          ),
        ),
        Positioned(
          top: -60,
          right: -40,
          child: _washBlob(200, AppColors.inkWash.withValues(alpha: 0.07)),
        ),
        Positioned(
          top: 120,
          left: -80,
          child: _washBlob(220, AppColors.inkWash.withValues(alpha: 0.05)),
        ),
        Positioned(
          bottom: 80,
          right: -50,
          child: _washBlob(160, AppColors.gold.withValues(alpha: 0.08)),
        ),
        Positioned(
          bottom: -30,
          left: 20,
          child: _washBlob(180, AppColors.primary.withValues(alpha: 0.06)),
        ),
        child,
      ],
    );
  }

  static Widget _washBlob(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
