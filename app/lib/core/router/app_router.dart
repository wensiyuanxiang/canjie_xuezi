import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/level_result.dart';
import '../../features/calibration/calibration_screen.dart';
import '../../features/collection/collection_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/level/level_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/world_map/world_map_screen.dart';
import '../constants/route_paths.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.home,
  routes: <RouteBase>[
    GoRoute(
      path: RoutePaths.home,
      builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.worldMap,
      builder: (BuildContext context, GoRouterState state) =>
          const WorldMapScreen(),
    ),
    GoRoute(
      path: '${RoutePaths.level}/:levelId',
      builder: (BuildContext context, GoRouterState state) {
        final String levelId = state.pathParameters['levelId'] ?? 'level-1';
        return LevelScreen(levelId: levelId);
      },
    ),
    GoRoute(
      path: RoutePaths.result,
      builder: (BuildContext context, GoRouterState state) {
        final Object? extra = state.extra;
        final LevelResult result = extra is LevelResult
            ? extra
            : LevelResult.placeholder(levelId: 'unknown');
        return ResultScreen(result: result);
      },
    ),
    GoRoute(
      path: RoutePaths.settings,
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
    ),
    GoRoute(
      path: RoutePaths.collection,
      builder: (BuildContext context, GoRouterState state) =>
          const CollectionScreen(),
    ),
    GoRoute(
      path: RoutePaths.calibration,
      builder: (BuildContext context, GoRouterState state) =>
          const CalibrationScreen(),
    ),
  ],
);
