/// No-op fallback for non-web platforms (used so the widget test suite,
/// which runs on the Dart VM rather than in a browser, can still
/// compile). The real implementation only runs on web — see
/// [sfx_pool_web.dart].
class SfxPool {
  SfxPool(String assetPath, {int poolSize = 6});

  void play() {}
}
