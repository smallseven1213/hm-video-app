import 'package:app_gp/screens/shorts_screen.dart';
import 'package:app_gp/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';

import '../screens/apps_screen/index.dart';
import '../screens/main_screen/index.dart';
import '../screens/main_screen/notice_dialog.dart';
import '../screens/user_screen/index.dart';
import '../widgets/custom_bottom_bar_item.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final bottomNavigatorController = Get.find<BottonNavigatorController>();

  final screens = {
    '/layout1': () => const HomeMainScreen(
          key: Key('layout1'),
          layoutId: 1,
        ),
    // '/layout2': () => ShortScreen(),
    '/layout2': () => const HomeMainScreen(
          key: Key('layout2'),
          layoutId: 2,
        ),
    '/game': () => const GameScreen(),
    '/apps': () => const AppsScreen(),
    '/user': () => const UserScreen()
  };

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var activeKey = bottomNavigatorController.activeKey.value;

        if (!screens.containsKey(activeKey)) {
          return Container();
        }

        final currentScreen = screens[activeKey]!();

        return Scaffold(
          body: Stack(
            children: [
              currentScreen,
              bottomNavigatorController.navigatorItems.isEmpty
                  ? Container()
                  : Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          child: Container(
                            height: 76,
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
                                children: bottomNavigatorController
                                    .navigatorItems
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => Expanded(
                                        child: CustomBottomBarItem(
                                          isActive:
                                              entry.value.path! == activeKey,
                                          iconSid: entry.value.photoSid!,
                                          activeIconSid:
                                              entry.value.clickEffect!,
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
                        ),
                      ),
                    ),
              const NoticeDialog()
            ],
          ),
        );
      },
    );
  }
}
