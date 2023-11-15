// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if (dart.library.html) 'dart:html' as html;

abstract class PlatformService {
  String getHost();
}

class AppPlatformService implements PlatformService {
  @override
  String getHost() {
    return html.window.location.host.split('.')[0];
  }
}
