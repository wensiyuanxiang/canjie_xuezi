class LevelResult {
  const LevelResult({
    required this.levelId,
    required this.correctCount,
    required this.missedCount,
    required this.wrongSlashCount,
    required this.maxCombo,
    this.levelCleared = true,
  });

  final String levelId;
  final int correctCount;
  final int missedCount;
  final int wrongSlashCount;
  final int maxCombo;

  /// 是否达成本关配额（用于地图解锁与字卡收集）。
  final bool levelCleared;

  factory LevelResult.placeholder({required String levelId}) {
    return LevelResult(
      levelId: levelId,
      correctCount: 0,
      missedCount: 0,
      wrongSlashCount: 0,
      maxCombo: 0,
      levelCleared: false,
    );
  }
}
