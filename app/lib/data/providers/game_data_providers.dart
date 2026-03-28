import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_record.dart';
import '../models/level_config.dart';
import '../repositories/game_content_repository.dart';

final levelsListProvider = FutureProvider<List<LevelConfig>>((Ref ref) async {
  return ref.read(gameContentRepositoryProvider).levels();
});

final charactersListProvider = FutureProvider<List<CharacterRecord>>((Ref ref) async {
  return ref.read(gameContentRepositoryProvider).characters();
});
