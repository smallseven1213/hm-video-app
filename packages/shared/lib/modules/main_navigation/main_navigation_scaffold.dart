import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_navigator_controller.dart';
import '../../models/navigation.dart';
import 'main_navigation_provider.dart';

class MainNavigationScaffold extends StatefulWidget {
  final String? defaultScreenKey;
  final Map<String, Widget Function()> screens;
  final Widget? screenNotFoundWidget;
  final Function(
      {required String activeKey,
      required List<Navigation> navigatorItems,
      required Function(String tabKey) changeTabKey}) bottomNavigationBarWidget;

  const MainNavigationScaffold(
      {Key? key,
      required this.screens,
      this.defaultScreenKey,
      this.screenNotFoundWidget,
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
      child: (String activeKey) {
        Widget currentScreen;

        if (widget.screens.containsKey(activeKey)) {
          currentScreen = widget.screens[activeKey]!();
        } else if (widget.screenNotFoundWidget != null) {
          currentScreen = widget.screenNotFoundWidget!;
        } else {
          currentScreen = const SizedBox.shrink();
        }
        return Scaffold(
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(100),
          //   child: Container(
          //     color: Colors.white,
          //   ),
          // ),
          body: currentScreen,
          bottomNavigationBar: widget.bottomNavigationBarWidget(
              activeKey: activeKey,
              navigatorItems: bottomNavigatorController.navigatorItems,
              changeTabKey: (String tabKey) {
                bottomNavigatorController.changeKey(tabKey);
              }),
        );
      },
    );
  }
}
