import 'package:flutter/material.dart';
import 'package:game/screens/enter_game_screen/index.dart' as game_lobby;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
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
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // height 5
                SizedBox(height: 5),
                ChannelSearchBar(
                  isWhiteTheme: true,
                ),
                Expanded(
                  child: game_lobby.EnterGame(
                    hideAppBar: true,
                  ),
                ),
              ],
            ))
        : const CircularProgressIndicator());
  }
}
