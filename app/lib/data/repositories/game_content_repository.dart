import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_record.dart';
import '../models/level_config.dart';
import '../sources/local_json_bundle.dart';

final gameContentRepositoryProvider = Provider<GameContentRepository>((Ref ref) {
  return GameContentRepository(LocalJsonBundle());
});

class GameContentRepository {
  GameContentRepository(this._bundle);

  final LocalJsonBundle _bundle;

  Future<List<CharacterRecord>> characters() => _bundle.loadCharacters();

  Future<List<LevelConfig>> levels() async {
    final List<LevelConfig> list = await _bundle.loadLevels();
    list.sort((LevelConfig a, LevelConfig b) => a.order.compareTo(b.order));
    return list;
  }

  Future<LevelConfig?> levelById(String id) async {
    final List<LevelConfig> all = await levels();
    for (final LevelConfig l in all) {
      if (l.id == id) {
        return l;
      }
    }
    return null;
  }
}
