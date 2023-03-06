import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
