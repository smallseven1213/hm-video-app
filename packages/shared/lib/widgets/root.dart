import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import '../navigator/delegate.dart';
import '../navigator/parser.dart';
import 'ad.dart';
import 'splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

typedef RouteObject = Map<String, RouteWidgetBuilder>;

class RootWidget extends StatelessWidget {
  final String homePath;
  final RouteObject routes;
  final String splashImage;
  final Map<ColorKeys, Color> appColors;
  final Function? loading;
  final Widget Function({int countdownSeconds})? countdown;
  final ThemeData? theme;
  final bool? i18nSupport;

  const RootWidget(
      {Key? key,
      required this.homePath,
      required this.routes,
      required this.splashImage,
      required this.appColors,
      this.theme,
      this.loading,
      this.countdown,
      this.i18nSupport})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RouteObject baseRoutes = {
      '/': (context, args) =>
          Splash(backgroundAssetPath: splashImage, loading: loading),
      '/ad': (context, args) => Ad(
            backgroundAssetPath: splashImage,
            loading: loading,
            countdown: countdown,
          ),
    };

    final delegate = MyRouteDelegate(
      homePath: homePath,
      routes: {...baseRoutes, ...routes},
    );

    final parser = MyRouteParser();

    if (i18nSupport == null || i18nSupport == false) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: delegate,
        routeInformationParser: parser,
        theme: theme,
      );
    }

    return MaterialApp.router(
      localizationsDelegates: [
        ...context.localizationDelegates,
        // GameLocalizationsDelegate(
        //     Localizations.localeOf(context).languageCode == 'zh_TW'
        //         ? enStrings
        //         : enStrings),
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      routerDelegate: delegate,
      routeInformationParser: parser,
      theme: theme,
    );
  }
}
