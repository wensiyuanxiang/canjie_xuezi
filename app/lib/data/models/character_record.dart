class CharacterRecord {
  const CharacterRecord({
    required this.id,
    required this.glyph,
    required this.pinyin,
    required this.meaning,
  });

  final String id;
  final String glyph;
  final String pinyin;
  final String meaning;

  factory CharacterRecord.fromJson(Map<String, dynamic> json) {
    return CharacterRecord(
      id: json['id'] as String? ?? '',
      glyph: json['glyph'] as String? ?? '',
      pinyin: json['pinyin'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
    );
  }
}
