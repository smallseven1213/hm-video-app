import 'package:app_gp/screens/shorts_screen.dart';
import 'package:app_gp/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';

import '../screens/apps_screen/index.dart';
import '../screens/main_screen/index.dart';
import '../screens/user_screen/index.dart';
import '../widgets/custom_bottom_bar_item.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final bottomNavigatorController = Get.find<BottonNavigatorController>();

  final screens = {
    '/layout1': const HomeMainScreen(),
    '/layout2': ShortScreen(),
    '/game': const GameScreen(),
    '/apps': const AppsScreen(),
    '/user': const UserScreen()
  };

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var screenIndex = screens.keys
            .toList()
            .indexOf(bottomNavigatorController.activeKey.value);

        if (screenIndex == -1) {
          return Container();
        }
        return Scaffold(
          body: Stack(
            children: [
              IndexedStack(
                index: screens.keys
                    .toList()
                    .indexOf(bottomNavigatorController.activeKey.value),
                children: screens.values.toList(),
              ),
              bottomNavigatorController.navigatorItems.isEmpty
                  ? Container()
                  : Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: 0.9, // 控制透明度，此处设置为0.9
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
                              children: bottomNavigatorController.navigatorItems
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Expanded(
                                      child: CustomBottomBarItem(
                                        isActive: entry.key == screenIndex,
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
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
