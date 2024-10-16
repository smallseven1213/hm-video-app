import 'package:flutter/material.dart';
import 'package:game/widgets/h5webview.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_navigator_controller.dart';
import '../../models/navigation.dart';
import '../../widgets/iframe.dart';
import 'main_navigation_provider.dart';

class MainNavigationScaffold extends StatefulWidget {
  final String? defaultScreenKey;
  final Map<String, Widget Function()> screens;
  final Widget? screenNotFoundWidget;
  final PreferredSizeWidget? appBar;
  final Function(
      {required String activeKey,
      required List<Navigation> navigatorItems,
      required Function(String tabKey) changeTabKey}) bottomNavigationBarWidget;

  const MainNavigationScaffold(
      {Key? key,
      required this.screens,
      this.defaultScreenKey,
      this.screenNotFoundWidget,
      this.appBar,
      required this.bottomNavigationBarWidget})
      : super(key: key);

  @override
  MainNavigationScaffoldState createState() => MainNavigationScaffoldState();
}

class MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  final bottomNavigatorController = Get.find<BottomNavigatorController>();

  @override
  Widget build(BuildContext context) {
    return MainNavigationProvider(
      child: (
        String activeKey,
        String navTitle,
      ) {
        Widget currentScreen;

        // Parse activeKey into path and query parameters
        String path = activeKey;
        Map<String, String> queryParameters = {};

        if (activeKey.contains('?')) {
          int idx = activeKey.indexOf('?');
          path = activeKey.substring(0, idx);
          String query = activeKey.substring(idx + 1);
          queryParameters = Uri.splitQueryString(query);
        }

        if (path == '/iframe') {
          String iframeUrl = queryParameters['url'] ?? '';
          currentScreen = WebViewPage(
            url: iframeUrl,
            title: navTitle,
          );
        } else if (widget.screens.containsKey(path)) {
          currentScreen = widget.screens[path]!();
        } else if (widget.screenNotFoundWidget != null) {
          currentScreen = widget.screenNotFoundWidget!;
        } else {
          currentScreen = const SizedBox.shrink();
        }

        return Scaffold(
          appBar: widget.appBar,
          body: currentScreen,
          bottomNavigationBar: widget.bottomNavigationBarWidget(
              activeKey: path,
              navigatorItems: bottomNavigatorController.navigatorItems,
              changeTabKey: (String tabKey) {
                bottomNavigatorController.changeKey(tabKey);
              }),
        );
      },
    );
  }
}
