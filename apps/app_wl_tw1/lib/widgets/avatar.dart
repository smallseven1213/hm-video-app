import 'package:app_wl_tw1/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shimmer/shimmer.dart';

class Avatar extends StatelessWidget {
  Avatar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final Function? onTap;
  final userController = Get.find<UserController>();

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF003068),
      highlightColor: const Color(0xFF00234d),
      child: Container(
        width: 60,
        height: 60,
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
            padding: const EdgeInsets.all(1),
            child: hasNoAvatar
                ? Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colors[ColorKeys.buttonBgDisable],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 32,
                        color: AppColors.colors[ColorKeys.textSecondary],
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
