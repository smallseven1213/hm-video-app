import 'package:app_tt/pages/apps.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/main_layout/main_layout_builder.dart';
import 'package:shared/modules/main_navigation/main_navigation_scaffold.dart';

import '../config/layouts.dart';
import '../screens/home/controllers/home_page_controller.dart';
import '../screens/home/menu.dart';
import '../screens/layout_game_screen.dart';
import '../screens/layout_home_screen/index.dart';
import '../screens/layout_user_screen/layout_user_screen.dart';
import '../widgets/layout_tab_item.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  late final HomePageController homePageController;

  @override
  void initState() {
    super.initState();
    Get.put(GameStartupController());
    homePageController = Get.put(HomePageController());

    ever(homePageController.displayDrawer, (bool displayDrawer) {
      if (displayDrawer) {
        _scaffoldKey.currentState?.openEndDrawer();
      } else {
        _scaffoldKey.currentState?.openEndDrawer();
      }
    });

    userApi.writeUserEnterHallRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFf0f0f0),
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
                Container(
                  padding: EdgeInsets.only(bottom: paddingBottom),
                  height: 76 + paddingBottom,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFe4e4e5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: navigatorItems
                        .asMap()
                        .entries
                        .map(
                          (entry) => Expanded(
                            child: LayoutTabItem(
                                isActive: entry.value.path! == activeKey,
                                label: entry.value.name!,
                                onTap: () => changeTabKey(entry.value.path!)),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          }),
      endDrawer: UserMenuWidget(),
    );
  }
}
