import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';

final logger = Logger();

class LayoutTabBarItem extends StatelessWidget {
  LayoutTabBarItem({
    Key? key,
    required this.index,
    required this.name,
  }) : super(key: key);

  final int index;
  final String name;

  final ChannelScreenTabController channelScreenTabController =
      Get.find<ChannelScreenTabController>();

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Obx(() {
        logger.i(
            'channelScreenTabController.tabIndex.value ${channelScreenTabController.tabIndex.value}');
        return Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: channelScreenTabController.tabIndex.value == index
                  ? AppColors.colors[ColorKeys.primary]
                  : const Color(0xffCFCECE),
              shadows: channelScreenTabController.tabIndex.value == index
                  ? [
                      Shadow(
                        color: AppColors.colors[ColorKeys.primary]!
                            .withOpacity(0.5),
                        offset: const Offset(0, 0),
                        blurRadius: 5,
                      ),
                    ]
                  : null),
        );
      }),
    );
  }
}
