/// Plays a short sound effect via a small round-robin pool of native
/// `<audio>` elements, so rapid retriggers (like wheel ticks) can
/// overlap instead of cutting each other off. Uses the browser's audio
/// element directly rather than a plugin, since this app only targets
/// web and the usual Flutter audio plugins have known reliability
/// issues in release web builds.
///
/// The web implementation is behind a conditional export so the widget
/// test suite (which runs on the Dart VM, not in a browser) can still
/// compile and run — it gets the no-op stub instead.
library;

export 'sfx_pool_stub.dart' if (dart.library.js_interop) 'sfx_pool_web.dart';
