/**
 * 如果任何App要使用遊戲相關功能，需要在RootWidget中加入GetX所做成的GameStartup Controller
 * 在初始化(Get.put) GameStartupController時，就要先設定下面一些東西:
 * 1. backToAppHome: () {}, 這裡在遊戲要"返回App端時", 就會call Controller.backToAppHome()然後返回app
 */

import 'package:get/get.dart';

class GameStartupController extends GetxController {
  Function backToAppHome;

  GameStartupController({required this.backToAppHome});
}
