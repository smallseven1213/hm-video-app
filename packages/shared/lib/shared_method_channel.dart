import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'shared_platform_interface.dart';

/// An implementation of [SharedPlatform] that uses method channels.
class MethodChannelShared extends SharedPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shared');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
