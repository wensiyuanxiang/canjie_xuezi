import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/level_config.dart';

final gameProgressProvider =
    StateNotifierProvider<GameProgressNotifier, GameProgressState>(
  (Ref ref) {
    return GameProgressNotifier();
  },
);

class GameProgressState {
  const GameProgressState({
    this.completedLevelIds = const <String>{},
    this.loaded = false,
  });

  final Set<String> completedLevelIds;
  final bool loaded;

  GameProgressState copyWith({
    Set<String>? completedLevelIds,
    bool? loaded,
  }) {
    return GameProgressState(
      completedLevelIds: completedLevelIds ?? this.completedLevelIds,
      loaded: loaded ?? this.loaded,
    );
  }

  int repairPercent(int totalLevels) {
    if (totalLevels <= 0) {
      return 0;
    }
    return ((completedLevelIds.length / totalLevels) * 100).round().clamp(0, 100);
  }
}

class GameProgressNotifier extends StateNotifier<GameProgressState> {
  GameProgressNotifier() : super(const GameProgressState()) {
    _load();
  }

  static const String _prefsKey = 'zaozi_completed_levels_v1';

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_prefsKey) ?? <String>[];
    state = GameProgressState(
      completedLevelIds: raw.toSet(),
      loaded: true,
    );
  }

  Future<void> markLevelCleared(String levelId) async {
    if (state.completedLevelIds.contains(levelId)) {
      return;
    }
    final Set<String> next = <String>{...state.completedLevelIds, levelId};
    state = state.copyWith(completedLevelIds: next);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, next.toList());
  }

  bool isLevelUnlocked(List<LevelConfig> ordered, int index) {
    if (index <= 0) {
      return true;
    }
    return state.completedLevelIds.contains(ordered[index - 1].id);
  }

  bool isLevelCompleted(String levelId) =>
      state.completedLevelIds.contains(levelId);

  int? currentLevelIndex(List<LevelConfig> ordered) {
    for (int i = 0; i < ordered.length; i++) {
      if (!isLevelUnlocked(ordered, i)) {
        continue;
      }
      if (!isLevelCompleted(ordered[i].id)) {
        return i;
      }
    }
    return null;
  }

  bool isCharacterCollected(String characterId, List<LevelConfig> levels) {
    for (final LevelConfig l in levels) {
      if (!state.completedLevelIds.contains(l.id)) {
        continue;
      }
      if (l.targetCharacterIds.contains(characterId)) {
        return true;
      }
    }
    return false;
  }

  int collectedCount(List<LevelConfig> levels, List<String> allCharIds) {
    int n = 0;
    for (final String id in allCharIds) {
      if (isCharacterCollected(id, levels)) {
        n++;
      }
    }
    return n;
  }
}
