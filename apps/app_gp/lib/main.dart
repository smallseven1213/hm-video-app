import 'package:app_gp/pages/game/deposit.dart';
import 'package:app_gp/pages/video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/utils/runningMain.dart';
import 'package:shared/widgets/root.dart';

import 'pages/home.dart';

void main() {
  runningMain(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootWidget(
        widget: GetMaterialApp(initialRoute: '/', enableLog: true, getPages: [
      GetPage(name: '/', page: () => Home()),
      GetPage(name: '/video', page: () => Video()),
      GetPage(name: '/game/deposit', page: () => GameDeposit()),
    ]));
  }
}
