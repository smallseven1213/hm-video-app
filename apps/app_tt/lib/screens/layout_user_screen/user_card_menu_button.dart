// UserCardMenuButton , is a stateless widget, has button, click to show a menu.
// import HomePageController, use toggleMenu() will to show menu.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/controllers/home_page_controller.dart';

class UserCardMenuButton extends StatelessWidget {
  const UserCardMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      builder: (controller) {
        return IconButton(
          onPressed: () {
            controller.toggleDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
