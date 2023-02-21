import 'package:app_gp/controllers/home_bottom_navigator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/ad.dart';
// import 'package:shared/utils/setupDependencies.dart';
// import 'package:shared/widgets/ad.dart';
// import 'package:shared/widgets/ad_screen.dart';
import 'package:shared/widgets/demo/ad.dart';
import 'package:shared/widgets/root.dart';
// import 'package:shared/widgets/splash.dart';
import 'package:shared/widgets/demo/splash.dart';

import 'pages/home.dart';

void main() {
  // DI shared package
  // setupDependencies();

  // DI app_gp package
  Get.put(HomeBottomNavigatorController());

  // start app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootWidget(
        widget: GetMaterialApp(initialRoute: '/', enableLog: true, getPages: [
      GetPage(name: '/', page: () => const SplashDemo()),
      GetPage(name: '/ad', page: () => const Ad()),
      GetPage(name: '/home', page: () => Home()),
    ]));
  }
}
