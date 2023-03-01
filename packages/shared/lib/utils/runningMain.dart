import 'package:flutter/material.dart';
import 'package:shared/utils/setupDependencies.dart';

Future<void> runningMain(Widget widget) async {
  // DI shared package
  setupDependencies();

  // DI app_gp package
  // TODO

  // start app
  runApp(widget);
}
