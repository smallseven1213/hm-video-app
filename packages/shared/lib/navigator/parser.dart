import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    print("routeInformation ${routeInformation.location}");

    return SynchronousFuture('/');
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return const RouteInformation(location: '/');
  }
}
