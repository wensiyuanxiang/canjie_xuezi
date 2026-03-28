import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/character_record.dart';
import '../models/level_config.dart';
import '../../core/constants/app_assets.dart';

class LocalJsonBundle {
  Future<List<CharacterRecord>> loadCharacters() async {
    final String raw = await rootBundle.loadString(AppAssets.charactersJson);
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((dynamic e) => CharacterRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LevelConfig>> loadLevels() async {
    final String raw = await rootBundle.loadString(AppAssets.levelsJson);
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((dynamic e) => LevelConfig.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
