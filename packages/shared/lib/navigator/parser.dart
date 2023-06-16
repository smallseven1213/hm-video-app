import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    logger.i("routeInformation ${routeInformation.location}");

    return SynchronousFuture('/');
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return const RouteInformation(location: '/');
  }
}
