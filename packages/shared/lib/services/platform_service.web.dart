import 'dart:html' as html;

abstract class PlatformService {
  String getHost();
}

class AppPlatformService implements PlatformService {
  @override
  String getHost() {
    return html.window.location.host.split('.')[0];
  }
}
