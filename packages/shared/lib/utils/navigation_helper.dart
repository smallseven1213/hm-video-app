import 'package:flutter/widgets.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void setNavigatorKey(GlobalKey<NavigatorState> key) {
  navigatorKey = key;
}

void navigateToHome() {
  navigatorKey.currentState!.pushNamed('/');
}
