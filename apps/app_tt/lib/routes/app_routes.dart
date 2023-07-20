library app_routes;

import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../pages/home.dart' as home_page;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.home.value: (context, args) => home_page.HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
};
