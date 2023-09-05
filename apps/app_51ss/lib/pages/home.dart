import 'package:app_51ss/screens/home/home_apps.dart';
import 'package:app_51ss/screens/video/video_player_area/flash_loading.dart';

import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/main_layout/main_layout_builder.dart';
import 'package:shared/modules/main_navigation/main_navigation_scaffold.dart';

import '../screens/main_screen/index.dart';
import '../screens/user_screen/index.dart';
import '../widgets/custom_bottom_bar_item.dart';

final logger = Logger();
UserApi userApi = UserApi();
final screens = {
  HomeNavigatorPathes.layout1: () => const MainLayoutBuilder(
        key: Key('layout1'),
        layoutId: 1,
        child: HomeMainScreen(
          layoutId: 1,
        ),
      ),
  HomeNavigatorPathes.layout2: () => const MainLayoutBuilder(
        key: Key('layout2'),
        layoutId: 2,
        child: HomeMainScreen(
          layoutId: 2,
        ),
      ),
  // HomeNavigatorPathes.game: () => const GameScreen(),
  HomeNavigatorPathes.apps: () => const HomeAppsScreen(),
  HomeNavigatorPathes.user: () => const UserScreen(),
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
  @override
  void initState() {
    super.initState();
    Get.put(GameStartupController());

    userApi.writeUserEnterHallRecord();
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationScaffold(
        screens: screens,
        screenNotFoundWidget: const Center(child: FlashLoading()),
        bottomNavigationBarWidget: (
            {required String activeKey,
            required List<Navigation> navigatorItems,
            required Function(String tabKey) changeTabKey}) {
          final paddingBottom = MediaQuery.of(context).padding.bottom;
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: paddingBottom),
                height: 76 + paddingBottom,
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
                                isActive: entry.value.path! == activeKey,
                                iconSid: entry.value.photoSid!,
                                activeIconSid: entry.value.clickEffect!,
                                label: entry.value.name!,
                                onTap: () => changeTabKey(entry.value.path!)),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
