import 'package:app_wl_id1/pages/coin.dart';
import 'package:app_wl_id1/pages/vip.dart';
import 'package:app_wl_id1/screens/home/home_apps.dart';
import 'package:app_wl_id1/widgets/wave_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:live_ui_basic/pages/live.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/main_layout/main_layout_builder.dart';
import 'package:shared/modules/main_navigation/main_navigation_scaffold.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

import '../config/layouts.dart';
import '../screens/enter_game_screen/index.dart';
import '../screens/main_screen/index.dart';
import '../screens/main_screen/notice_dialog.dart';
import '../screens/user_screen/index.dart';
import '../widgets/custom_bottom_bar_item.dart';
import '../widgets/shared_app_bar/shared_app_bar.dart';

final logger = Logger();
UserApi userApi = UserApi();
final screens = {
  HomeNavigatorPathes.layout1: () => MainLayoutBuilder(
        key: Key('layout${layouts[0]}'),
        layoutId: layouts[0],
        child: HomeMainScreen(
          layoutId: layouts[0],
        ),
        // child: HomeMainScreen(
        //   layoutId: layouts[0],
        // ),
      ),
  HomeNavigatorPathes.layout2: () => MainLayoutBuilder(
        key: Key('layout${layouts[1]}'),
        layoutId: layouts[1],
        child: HomeMainScreen(
          layoutId: layouts[1],
        ),
      ),
  HomeNavigatorPathes.game: () => const Scaffold(
        appBar: SharedAppBar(),
        body: EnterGame(),
      ),
  HomeNavigatorPathes.apps: () => const HomeAppsScreen(),
  HomeNavigatorPathes.user: () => const UserScreen(),
  HomeNavigatorPathes.live: () => const LivePage(),
  HomeNavigatorPathes.coin: () => const CoinPage(),
  HomeNavigatorPathes.vip: () => const VipPage(),
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
    Get.put(UIController());
  }

  @override
  Widget build(BuildContext context) {
    final UIController uiController = Get.find<UIController>();

    return MainNavigationScaffold(
        // appBar: SharedAppBar(),
        screens: screens,
        screenNotFoundWidget: const Center(
          child: WaveLoading(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            duration: Duration(milliseconds: 1000),
            size: 17,
            itemCount: 3,
          ),
        ),
        bottomNavigationBarWidget: (
            {required String activeKey,
            required List<Navigation> navigatorItems,
            required Function(String tabKey) changeTabKey}) {
          return Stack(
            children: [
              Obx(() {
                return uiController.displayHomeNavigationBar.value
                    ? UIBottomSafeArea(
                        child: Container(
                          height: 76,
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
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              if (widget.defaultScreenKey == null) const NoticeDialog()
            ],
          );
        });
  }
}
