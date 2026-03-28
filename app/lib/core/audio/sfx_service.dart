import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_assets.dart';

final AudioCache _sfxCache = AudioCache(prefix: 'assets/');

class SfxService {
  static final List<AudioPlayer> _pool = <AudioPlayer>[];
  static int _next = 0;
  static Future<void>? _warmUp;

  /// Call from [main] after global audio context so SFX does not allocate and
  /// dispose a native player per tap (Darwin audio session churn can mute BGM).
  static Future<void> warmUp() {
    _warmUp ??= _warmUpImpl();
    return _warmUp!;
  }

  static Future<void> _warmUpImpl() async {
    if (_pool.isNotEmpty) {
      return;
    }
    for (var i = 0; i < 3; i++) {
      final AudioPlayer player = AudioPlayer()..audioCache = _sfxCache;
      await player.setReleaseMode(ReleaseMode.stop);
      _pool.add(player);
    }
  }

  Future<void> playCut() => _play(AppAssets.sfxCut);
  Future<void> playComboUp() => _play(AppAssets.sfxComboUp);
  Future<void> playSlashWrong() => _play(AppAssets.sfxSlashWrong);
  Future<void> playLevelClear() => _play(AppAssets.sfxLevelClear, volume: 0.7);

  Future<void> _play(String file, {double volume = 0.5}) async {
    try {
      await warmUp();
      final AudioPlayer player = _pool[_next % _pool.length];
      _next++;
      await player.stop();
      await player.setVolume(volume);
      await player.play(AssetSource(file));
    } catch (e) {
      debugPrint('[SfxService] Failed to play $file: $e');
    }
  }
}
