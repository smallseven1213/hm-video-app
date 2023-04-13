import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';
import 'package:shared/shared_platform_interface.dart';
import 'package:shared/shared_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSharedPlatform
    with MockPlatformInterfaceMixin
    implements SharedPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SharedPlatform initialPlatform = SharedPlatform.instance;

  test('$MethodChannelShared is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShared>());
  });

  test('getPlatformVersion', () async {
    Shared sharedPlugin = Shared();
    MockSharedPlatform fakePlatform = MockSharedPlatform();
    SharedPlatform.instance = fakePlatform;

    expect(await sharedPlugin.getPlatformVersion(), '42');
  });
}
