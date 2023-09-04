import 'package:app_ra/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/main_layout/main_layout_builder.dart';
import 'package:shared/modules/main_navigation/main_navigation_scaffold.dart';

import '../config/layouts.dart';
import '../screens/home/custom_bottom_bar_item.dart';
import '../screens/layout_game_screen.dart';
import '../screens/layout_home_screen/index.dart';
import '../screens/layout_user_screen/layout_user_screen.dart';
import 'apps.dart';

UserApi userApi = UserApi();
final screens = {
  HomeNavigatorPathes.layout1: () => MainLayoutBuilder(
        key: Key('layout${layouts[0]}'),
        layoutId: layouts[0],
        child: LayoutHomeScreen(
          layoutId: layouts[0],
        ),
      ),
  HomeNavigatorPathes.layout2: () => MainLayoutBuilder(
        key: Key('layout${layouts[1]}'),
        layoutId: layouts[1],
        child: LayoutHomeScreen(
          layoutId: layouts[1],
        ),
      ),
  HomeNavigatorPathes.game: () => const LayoutGameScreen(),
  HomeNavigatorPathes.apps: () => const AppsPage(),
  HomeNavigatorPathes.user: () => const LayoutUserScreen()
};

class HomePage extends StatefulWidget {
  final String? defaultScreenKey;
  HomePage({Key? key, this.defaultScreenKey = HomeNavigatorPathes.layout1})
      : super(key: key);

  final bottomNavigatorController = Get.find<BottomNavigatorController>();
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  late final UIController uiController;

  @override
  void initState() {
    super.initState();
    uiController = Get.put(UIController());
    Get.put(GameStartupController());

    userApi.writeUserEnterHallRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colors[ColorKeys.background],
      body: MainNavigationScaffold(
          screens: screens,
          screenNotFoundWidget: const Center(
            child: Center(
              child: Text('loading...'),
            ),
          ),
          bottomNavigationBarWidget: (
              {required String activeKey,
              required List<Navigation> navigatorItems,
              required Function(String tabKey) changeTabKey}) {
            final paddingBottom = MediaQuery.of(context).padding.bottom;

            return Stack(
              children: [
                Obx(() {
                  return uiController.displayHomeNavigationBar.value
                      ? Container(
                          padding: EdgeInsets.only(bottom: paddingBottom),
                          height: 76 + paddingBottom,
                          decoration: const BoxDecoration(
                            borderRadius: kIsWeb
                                ? null
                                : BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                            gradient: kIsWeb
                                ? null
                                : LinearGradient(
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
                              children: navigatorItems
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
                                          onTap: () =>
                                              changeTabKey(entry.value.path!)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ],
            );
          }),
    );
  }
}
