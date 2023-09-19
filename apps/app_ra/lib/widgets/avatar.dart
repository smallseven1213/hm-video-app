import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shimmer/shimmer.dart';

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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF003068),
      highlightColor: const Color(0xFF00234d),
      child: Container(
        width: width ?? 60,
        height: height ?? 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Obx(() {
        var isLoading = userController.isLoading.value;
        var hasNoAvatar = userController.info.value.roles.contains('guest') ||
            userController.info.value.avatar == null;

        if (isLoading && userController.info.value.avatar == null) {
          return _buildShimmer();
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
                              const Color(0xFF00B2FF),
                              const Color(0xFFCCEAFF),
                              const Color(0xFF00B2FF),
                            ]
                          : [
                              const Color(0xFFFFC700),
                              const Color(0xFFFE8900),
                              const Color(0xFFFFC700),
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
                  )
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
