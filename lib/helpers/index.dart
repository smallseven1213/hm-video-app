import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

export 'getx.dart';

bool isDebug() {
  return kIsWeb && html.window.location.host.contains(RegExp('pkonly8'));
}
