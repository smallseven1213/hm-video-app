import 'package:app_gs/screens/games/game_lobby_screen/lobby.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

import '../config/layouts.dart';
import '../screens/apps_screen/index.dart';
import '../screens/main_screen/index.dart';
import '../screens/main_screen/notice_dialog.dart';
import '../screens/user_screen/index.dart';
import '../widgets/custom_bottom_bar_item.dart';

final logger = Logger();
final screens = {
  '/layout1': () => HomeMainScreen(
        key: Key('layout${layouts[0]}'),
        layoutId: layouts[0],
      ),
  '/layout2': () => HomeMainScreen(
        key: Key('layout${layouts[1]}'),
        layoutId: layouts[1],
      ),
  '/game': () => const GameScreen(),
  '/apps': () => const AppsScreen(),
  '/user': () => const UserScreen()
};

class HomePage extends StatefulWidget {
  final String? defaultScreenKey;
  HomePage({Key? key, this.defaultScreenKey = '/layout1'}) : super(key: key);

  final bottomNavigatorController = Get.find<BottonNavigatorController>();
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  final bottomNavigatorController = Get.find<BottonNavigatorController>();
  UserApi userApi = UserApi();

  // init
  @override
  void initState() {
    if (widget.defaultScreenKey != null) {
      bottomNavigatorController.changeKey(widget.defaultScreenKey!);
    }
    for (var layout in layouts) {
      Get.put(ChannelScreenTabController(),
          tag: 'channel-screen-$layout', permanent: false);
      Get.put(LayoutController(layout), tag: 'layout$layout', permanent: false);
    }

    Get.put(GameStartupController());

    userApi.writeUserEnterHallRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var activeKey = bottomNavigatorController.activeKey.value;

        if (!screens.containsKey(activeKey)) {
          return Container();
        }

        final currentScreen = screens[activeKey]!();
        final paddingBottom = MediaQuery.of(context).padding.bottom;

        return Scaffold(
            body: currentScreen,
            bottomNavigationBar: bottomNavigatorController
                    .navigatorItems.isEmpty
                ? null
                : Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: paddingBottom),
                        height: 76 + paddingBottom,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF000000),
                              Color(0xFF002869),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Row(
                            children: bottomNavigatorController.navigatorItems
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Expanded(
                                    child: CustomBottomBarItem(
                                      isActive: entry.value.path! == activeKey,
                                      iconSid: entry.value.photoSid!,
                                      activeIconSid: entry.value.clickEffect!,
                                      label: entry.value.name!,
                                      onTap: () => bottomNavigatorController
                                          .changeKey(entry.value.path!),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      if (widget.defaultScreenKey == null) const NoticeDialog()
                    ],
                  ));
      },
    );
  }
}
