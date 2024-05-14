import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class UIController extends GetxController {
  // final int layoutId;
  final RxBool isFullscreen = false.obs;
  var displayChannelTab = true.obs;
  var displayHomeNavigationBar = true.obs;
  var isShortVideoMute = kIsWeb ? true.obs : false.obs;
  var isIphoneSafari = false.obs;

  UIController();

  @override
  void onInit() {
    super.onInit();
    detectMobileDevice();
  }

  // detect if the device is a mobile device
  Future<void> detectMobileDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    // 檢查webBrowserInfo userAgent是不是有iPhone
    var isIphoneSafari = webBrowserInfo.userAgent!.contains('iPhone');
    if (isIphoneSafari) {
      this.isIphoneSafari.value = true;
      print("isIphoneSafari");
    }
  }

  void setDisplay(bool value) {
    displayChannelTab.value = value;
    displayHomeNavigationBar.value = value;
  }

  void toggleShortVideoMute() {
    isShortVideoMute.value = !isShortVideoMute.value;
  }
}
