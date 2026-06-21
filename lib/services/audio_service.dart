import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _tapPlayer = AudioPlayer();
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    await _tapPlayer.setReleaseMode(ReleaseMode.stop);
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    _initialized = true;
  }

  static Future<void> playTap(String soundType) async {
    try {
      String asset;
      switch (soundType) {
        case 'om':
          asset = 'sounds/om_short.mp3';
          break;
        case 'beads':
          asset = 'sounds/bead_click.mp3';
          break;
        case 'bell':
        default:
          asset = 'sounds/temple_bell.mp3';
          break;
      }
      await _tapPlayer.stop();
      await _tapPlayer.play(AssetSource(asset));
    } catch (_) {}
  }

  static Future<void> playMalaComplete() async {
    try {
      await _tapPlayer.stop();
      await _tapPlayer.play(AssetSource('sounds/mala_complete.mp3'));
    } catch (_) {}
  }

  static Future<void> playGoalComplete() async {
    try {
      await _tapPlayer.stop();
      await _tapPlayer.play(AssetSource('sounds/goal_complete.mp3'));
    } catch (_) {}
  }

  static Future<void> startBackgroundMusic() async {
    try {
      await _bgPlayer.stop();
      await _bgPlayer.play(AssetSource('sounds/meditation_bg.mp3'));
      await _bgPlayer.setVolume(0.3);
    } catch (_) {}
  }

  static Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
  }

  static Future<void> dispose() async {
    await _tapPlayer.dispose();
    await _bgPlayer.dispose();
  }
}
