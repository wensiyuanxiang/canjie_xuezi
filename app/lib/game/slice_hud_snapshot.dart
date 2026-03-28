class SliceHudSnapshot {
  const SliceHudSnapshot({
    required this.timeLeft,
    required this.correct,
    required this.quota,
    required this.combo,
    required this.wrong,
    required this.missed,
    required this.ended,
  });

  final double timeLeft;
  final int correct;
  final int quota;
  final int combo;
  final int wrong;
  final int missed;
  final bool ended;

  static SliceHudSnapshot initial() {
    return const SliceHudSnapshot(
      timeLeft: 0,
      correct: 0,
      quota: 5,
      combo: 0,
      wrong: 0,
      missed: 0,
      ended: false,
    );
  }

  bool differsFrom(SliceHudSnapshot o) {
    return (o.timeLeft - timeLeft).abs() > 0.09 ||
        o.correct != correct ||
        o.quota != quota ||
        o.combo != combo ||
        o.wrong != wrong ||
        o.missed != missed ||
        o.ended != ended;
  }
}
