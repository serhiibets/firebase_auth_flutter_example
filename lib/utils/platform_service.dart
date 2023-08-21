import 'package:flutter/foundation.dart';

class PlatformService {
  bool get isMobile => (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS);

  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  bool get isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  /// Gets the platform where the application is executed.
  TargetPlatform get targetPlatform => defaultTargetPlatform;
}
