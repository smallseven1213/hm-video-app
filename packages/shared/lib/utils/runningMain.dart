import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared/utils/setupDependencies.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> runningMain(Widget widget) async {
  // start app
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://fa3ef717273444e6887f4e7f32901535@o4504800404373504.ingest.sentry.io/4504800405225472';

      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      await Hive.initFlutter();

      // DI shared package
      setupDependencies();

      // DI app_gp package

      // Running Main
      runApp(widget);
    },
  );
}
