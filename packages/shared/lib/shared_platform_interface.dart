import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'shared_method_channel.dart';

abstract class SharedPlatform extends PlatformInterface {
  /// Constructs a SharedPlatform.
  SharedPlatform() : super(token: _token);

  static final Object _token = Object();

  static SharedPlatform _instance = MethodChannelShared();

  /// The default instance of [SharedPlatform] to use.
  ///
  /// Defaults to [MethodChannelShared].
  static SharedPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SharedPlatform] when
  /// they register themselves.
  static set instance(SharedPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
