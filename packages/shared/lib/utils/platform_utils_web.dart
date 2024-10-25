// platform_utils_web.dart

import 'dart:html' as html;
import 'package:js/js_util.dart' as js_util;

bool isInStandaloneMode() {
  // 檢查 navigator.standalone (iOS PWA)
  final standalone =
      js_util.getProperty(html.window.navigator, 'standalone') as bool?;

  // 檢查 display-mode: standalone (其他平台 PWA)
  final displayModeStandalone =
      html.window.matchMedia('(display-mode: standalone)').matches;

  // 只要其中一個為 true 就回傳 true
  return (standalone == true) || displayModeStandalone;
}
