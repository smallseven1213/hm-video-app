import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/main_navigation/main_navigation_scaffold.dart';

import '../screens/main_screen/index.dart';

final logger = Logger();
UserApi userApi = UserApi();
final screens = {
  HomeNavigatorPathes.layout1: () => const HomeMainScreen(
        layoutId: 0,
      ),
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
        screenNotFoundWidget: const Center(
          child: Text('screenNotFoundWidget'),
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
                child: const ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Text('CustomBottomBarItem'),
                ),
              ),
            ],
          );
        });
  }
}
