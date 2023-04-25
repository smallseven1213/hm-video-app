import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
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
      baseColor: Colors.white.withOpacity(0.4),
      highlightColor: Colors.white.withOpacity(0.2),
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
    return InkWell(
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
              // boxShadow: [
              //   if (hasNoAvatar)
              //     const BoxShadow(
              //       color: Color(0xFF456EFF),
              //       blurRadius: 9,
              //       spreadRadius: 0,
              //     )
              //   else
              //     const BoxShadow(
              //       color: Color(0xFFFFC700),
              //       blurRadius: 9,
              //       spreadRadius: 0,
              //     ),
              // ],
              gradient: LinearGradient(
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
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF002D46),
                          Color(0xFF0085D0),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Image(
                          width: 33,
                          image:
                              AssetImage('assets/images/user_not_login.png')),
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
