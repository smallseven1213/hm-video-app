// platform_utils_web.dart

import 'dart:html' as html;
import 'package:js/js_util.dart' as js_util;

bool isInStandaloneMode() {
  // 获取用户代理字符串
  final userAgent = html.window.navigator.userAgent.toLowerCase();

  // 检测是否为 iOS 设备
  final isIOS = userAgent.contains('iphone') ||
      userAgent.contains('ipad') ||
      userAgent.contains('ipod');

  if (isIOS) {
    // 在 iOS 上，通过 navigator.standalone 属性检测
    final standalone =
        js_util.getProperty(html.window.navigator, 'standalone') as bool?;
    return standalone == true;
  } else {
    // 在其他平台上，通过 display-mode 媒体查询检测
    final isStandalone =
        html.window.matchMedia('(display-mode: standalone)').matches;
    return isStandalone;
  }
}
