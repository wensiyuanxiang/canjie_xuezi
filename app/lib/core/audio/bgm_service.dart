import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/bgm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_assets.dart';

final AudioCache _appAudioCache = AudioCache(prefix: 'assets/');

enum BgmTrack { home, level }

final bgmServiceProvider = Provider<BgmService>((_) => BgmService());

class BgmService {
  final Bgm _bgm = Bgm(audioCache: _appAudioCache);
  BgmTrack? _current;
  bool _initialized = false;

  /// [Bgm.play] releases and re-binds one native player; concurrent calls
  /// (e.g. LevelScreen.dispose + HomeScreen.initState both play home) corrupt
  /// state and can mute all audio until restart.
  Future<void> _chain = Future<void>.value();

  Future<void> _ensureInit() async {
    if (!_initialized) {
      _initialized = true;
      await _bgm.initialize();
    }
  }

  Future<void> play(BgmTrack track, {double volume = 0.35}) {
    final Future<void> op = _chain.then((_) => _playSerial(track, volume: volume));
    _chain = op.onError((Object e, StackTrace st) {
      debugPrint('[BgmService] play chain: $e');
    });
    return op;
  }

  Future<void> _playSerial(BgmTrack track, {required double volume}) async {
    await _ensureInit();

    // flame_audio Bgm keeps isPlaying true after app background pause, so we
    // must check the native player state or returning to Home never resumes.
    if (_current == track && _bgm.isPlaying) {
      final PlayerState nativeState = _bgm.audioPlayer.state;
      if (nativeState == PlayerState.playing) {
        return;
      }
      if (nativeState == PlayerState.paused) {
        try {
          await _bgm.resume();
        } catch (e) {
          debugPrint('[BgmService] Failed to resume: $e');
          _current = null;
        }
        return;
      }
    }

    _current = track;
    final String file = switch (track) {
      BgmTrack.home => AppAssets.bgmHome,
      BgmTrack.level => AppAssets.bgmLevel,
    };
    try {
      await _bgm.play(file, volume: volume);
    } catch (e) {
      debugPrint('[BgmService] Failed to play $file: $e');
      _current = null;
    }
  }

  Future<void> stop() {
    final Future<void> op = _chain.then((_) => _stopSerial());
    _chain = op.onError((Object e, StackTrace st) {
      debugPrint('[BgmService] stop chain: $e');
    });
    return op;
  }

  Future<void> _stopSerial() async {
    _current = null;
    try {
      await _bgm.stop();
    } catch (e) {
      debugPrint('[BgmService] Failed to stop: $e');
    }
  }

  Future<void> dispose() async {
    _current = null;
    await _bgm.dispose();
  }
}
