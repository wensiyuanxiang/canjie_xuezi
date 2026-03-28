class LevelConfig {
  const LevelConfig({
    required this.id,
    required this.order,
    required this.title,
    required this.targetCharacterIds,
    required this.targetGlyph,
    required this.missionPhrase,
    required this.kidHint,
    required this.repairStory,
    required this.mapPosition,
    required this.mapTeaser,
  });

  final String id;
  final int order;
  final String title;
  final List<String> targetCharacterIds;
  final String targetGlyph;
  final String missionPhrase;
  final String kidHint;
  final String repairStory;
  final String mapPosition;
  final String mapTeaser;

  bool get isBoss => id.contains('boss');

  factory LevelConfig.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? raw = json['targetCharacterIds'] as List<dynamic>?;
    return LevelConfig(
      id: json['id'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      targetCharacterIds:
          raw?.map((dynamic e) => e.toString()).toList() ?? const <String>[],
      targetGlyph: json['targetGlyph'] as String? ?? '',
      missionPhrase: json['missionPhrase'] as String? ?? '切开目标字',
      kidHint: json['kidHint'] as String? ?? '',
      repairStory: json['repairStory'] as String? ?? '',
      mapPosition: json['mapPosition'] as String? ?? '',
      mapTeaser: json['mapTeaser'] as String? ?? '',
    );
  }
}
