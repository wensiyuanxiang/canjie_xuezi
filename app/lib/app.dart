import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class ZaoziApp extends StatelessWidget {
  const ZaoziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '仓颉切字',
      debugShowCheckedModeBanner: false,
      theme: buildZaoziTheme(),
      routerConfig: appRouter,
    );
  }
}
