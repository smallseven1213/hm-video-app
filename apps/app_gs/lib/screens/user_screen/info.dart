import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/avatar.dart';

final logger = Logger();

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  UserController get userController => Get.find<UserController>();

  Widget _buildShimmer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.4),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00B2FF),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000916),
            Color(0xFF003F6C),
          ],
          stops: [0.0, 1.0],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Obx(() {
        var isLoading = userController.isLoading.value;
        return Stack(
          children: [
            Row(
              children: [
                Avatar(),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userController.info.value.roles.contains('vip'))
                        const Image(
                          image: AssetImage(
                              'assets/images/user_screen_info_vip.png'),
                          width: 20,
                        ),
                      Row(
                        children: [
                          if (isLoading)
                            _buildShimmer(width: 80, height: 14)
                          else
                            Text(
                              userController.info.value.nickname ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          if (!userController.info.value.roles
                              .contains('guest'))
                            InkWell(
                              onTap: () {
                                // MyRouteDelegate.of(context)
                                //     .push('/user/config');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/user_screen_info_editor.png'),
                                  width: 15,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if (isLoading)
                        _buildShimmer(width: 50, height: 12)
                      else
                        Text(
                          'ID: ${userController.info.value.uid}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                if (userController.info.value.roles.contains('guest'))
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        MyRouteDelegate.of(context).push(AppRoutes.login.value);
                      },
                      child: const Text(
                        '註冊/登入',
                        style: TextStyle(
                          color: Color(0xffFFC700),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color(0xffFF7A00),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  // MyRouteDelegate.of(context).push(AppRoutes.value);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: const Image(
                    image: AssetImage(
                        'assets/images/user_screen_config_button.png'),
                    width: 15,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 30,
              child: InkWell(
                onTap: () {
                  MyRouteDelegate.of(context)
                      .push(AppRoutes.notifications.value);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: const Image(
                    image: AssetImage(
                        'assets/images/user_screen_notice_button.png'),
                    width: 15,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
