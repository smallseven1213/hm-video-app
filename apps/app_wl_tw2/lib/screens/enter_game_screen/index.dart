import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:game/screens/lobby.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';

import '../main_screen/channel_search_bar.dart';

final logger = Logger();

class EnterGame extends StatefulWidget {
  const EnterGame({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterGame> createState() => _EnterGame();
}

class _EnterGame extends State<EnterGame> {
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  @override
  void initState() {
    super.initState();
    gameConfigController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => gameConfigController.gamePageColor.value != 0
        ? const Scaffold(
            backgroundColor: Color(0xff1F2123),
            body: Column(
              children: [
                ChannelSearchBar(),
                SizedBox(height: 5),
                Expanded(child: GameLobby(hideAppBar: true))
              ],
            ))
        : const CircularProgressIndicator());
  }
}
