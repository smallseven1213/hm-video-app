import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/models/command.dart';

import 'user_diamonds.dart';

class Resize extends StatelessWidget {
  const Resize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ShareView();
          },
        );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/resize_button.webp',
          width: 33,
          height: 33),
    );
  }
}

class ShareView extends StatelessWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
