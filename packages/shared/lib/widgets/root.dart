import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/localization/en.dart';
import 'package:game/localization/id.dart';
import 'package:game/localization/vi.dart';
import 'package:game/localization/zh.dart';
import 'package:game/localization/zn.dart';
import 'package:get_storage/get_storage.dart';

import 'package:live_ui_basic/localization/live_localization_delegate.dart';
import 'package:live_ui_basic/localization/en.dart';
import 'package:live_ui_basic/localization/jp.dart';
import 'package:live_ui_basic/localization/id.dart';
import 'package:live_ui_basic/localization/vi.dart';
import 'package:live_ui_basic/localization/zh.dart';
import 'package:live_ui_basic/localization/zn.dart';

import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/localization/en.dart';
import 'package:shared/localization/jp.dart';
import 'package:shared/localization/id.dart';
import 'package:shared/localization/vi.dart';
import 'package:shared/localization/zh.dart';
import 'package:shared/localization/zn.dart';

import 'package:get/get.dart';
import 'package:shared/models/color_keys.dart';
import '../controllers/system_config_controller.dart';
import '../navigator/delegate.dart';
import '../navigator/parser.dart';
import 'ad.dart';
import 'splash.dart';

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
  final List<String> dlJsonHosts;
  final Locale? defaultLocale;

  const RootWidget(
      {Key? key,
      required this.homePath,
      required this.routes,
      required this.splashImage,
      required this.appColors,
      this.theme,
      this.loading,
      this.countdown,
      this.i18nSupport,
      this.defaultLocale,
      required this.dlJsonHosts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<SystemConfigController>().setDlJsonHosts(dlJsonHosts);
    final RouteObject baseRoutes = {
      '/': (context, args) => Splash(
            backgroundAssetPath: splashImage,
            loading: loading,
            skipNavigation: args['skipNavigation'] == null
                ? false
                : args['skipNavigation'] as bool,
          ),
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
    GetStorage box = GetStorage('locale');

    // if defaultLocale not null, then use it
    if (defaultLocale != null) {
      context.setLocale(defaultLocale!);
      box.write('locale',
          '${defaultLocale!.languageCode}_${defaultLocale!.countryCode}');
    } else {
      context.setLocale(const Locale('zh_TW'));
      box.write('locale', 'zh_TW');
    }

    return MaterialApp.router(
      localizationsDelegates: [
        GameLocalizationsDelegate({
          'en-US': enUsStrings,
          'zh-TW': zhTwStrings,
          'zh-CN': zhCnStrings,
          'vi-VN': viVnStrings,
          'id-ID': idIdStrings,
          // 'ja-JP': jpStrings,
        }),
        LiveLocalizationsDelegate({
          'en-US': liveEnUsStrings,
          'zh-TW': liveZhTwStrings,
          'zh-CN': liveZhCnStrings,
          'vi-VN': liveViVnStrings,
          'id-ID': liveIdIdStrings,
          'ja_JP': liveJaJpStrings,
        }),
        SharedLocalizationsDelegate({
          'en-US': sharedEnUsStrings,
          'zh-TW': sharedZhTwStrings,
          'zh-CN': sharedZhCnStrings,
          'vi-VN': sharedViVnStrings,
          'id-ID': sharedIdIdStrings,
          'ja_JP': sharedJaJpStrings,
        }),
        ...context.localizationDelegates,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      routerDelegate: delegate,
      routeInformationParser: parser,
      theme: theme,
      builder: (context, child) {
        if (kIsWeb) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          );
        } else {
          return child!;
        }
      },
    );
  }
}
