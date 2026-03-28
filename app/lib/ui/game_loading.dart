import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class GameLoadingCenter extends StatelessWidget {
  const GameLoadingCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: AppColors.gold,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '载入中…',
            style: TextStyle(
              color: AppColors.grayBlue,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
