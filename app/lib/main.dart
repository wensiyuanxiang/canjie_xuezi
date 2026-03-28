import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/audio/sfx_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AudioCache.instance.prefix = 'assets/';
  await AudioPlayer.global.setAudioContext(
    AudioContextConfig(
      focus: AudioContextConfigFocus.mixWithOthers,
    ).build(),
  );
  await SfxService.warmUp();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: ZaoziApp()));
}
