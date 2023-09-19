import 'package:app_ra/widgets/shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';

class Avatar extends StatelessWidget {
  Avatar({
    Key? key,
    this.onTap,
    this.height,
    this.width,
  }) : super(key: key);

  final Function? onTap;
  final double? height;
  final double? width;
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Obx(() {
        var isLoading = userController.isLoading.value;
        var hasNoAvatar = userController.info.value.roles.contains('guest') ||
            userController.info.value.avatar == null;

        if (isLoading && userController.info.value.avatar == null) {
          return const ShimmerWidget(width: 60, height: 60);
        }
        return Container(
            padding: const EdgeInsets.all(
                1), // Add padding to create the border effect
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: kIsWeb
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: hasNoAvatar
                          ? [
                              const Color(0xFFD9D9D9),
                              const Color(0xFFFDDCEF),
                              const Color(0xFFD9D9D9),
                            ]
                          : [
                              const Color(0xFFD9D9D9),
                              const Color(0xFFFDDCEF),
                              const Color(0xFFD9D9D9),
                            ],
                    ),
            ),
            child: hasNoAvatar
                ? Container(
                    width: width ?? 60,
                    height: height ?? 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFDDCEF),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 144, 144, 144),
                      size: 30,
                    ))
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage(userController.info.value.avatar ?? ''),
                  ));
      }),
    );
  }
}
