import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';

import '../localization/i18n.dart';

class GameProvider extends StatelessWidget {
  final Widget child;

  const GameProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GameStartupController());
    return child;
  }
}
