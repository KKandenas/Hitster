import 'package:web/web.dart' as web;

/// Plays a short sound effect via a small round-robin pool of native
/// `<audio>` elements, so rapid retriggers (like wheel ticks) can
/// overlap instead of cutting each other off. Uses the browser's audio
/// element directly rather than a plugin, since this app only targets
/// web and the usual Flutter audio plugins have known reliability
/// issues in release web builds.
class SfxPool {
  final List<web.HTMLAudioElement> _pool;
  int _next = 0;

  SfxPool(String assetPath, {int poolSize = 6})
      : _pool = List.generate(poolSize, (_) {
          final audio = web.HTMLAudioElement()
            ..src = assetPath
            ..preload = 'auto';
          return audio;
        });

  void play() {
    final audio = _pool[_next];
    _next = (_next + 1) % _pool.length;
    audio.currentTime = 0;
    audio.play();
  }
}
