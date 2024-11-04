import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../localization/i18n.dart';
import '../screens/vip/tab_section.dart';
import '../widgets/avatar.dart';
import '../widgets/custom_app_bar.dart';

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  VipPageState createState() => VipPageState();
}

class VipPageState extends State<VipPage> {
  late UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUserInfo();
      userController.fetchUserInfoV2();
    });
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: UserInfoV2Consumer(
        child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
          return Row(
            children: [
              Avatar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${info.uid}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _vipBookmark(String vipExpiredAt) {
    return UserInfoV2Consumer(
        child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
      return isVIP
          ? Container(
              width: 135,
              height: 42,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFFF0BBC2), Color(0xFFE18AB5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    Text(
                      I18n.vipMember,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${I18n.validUntil}$vipExpiredAt',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ))
          : Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1320),
      appBar: CustomAppBar(title: I18n.vipMember),
      body: Column(
        children: [
          // User Profile Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildUserInfo(),
              _vipBookmark(userController.infoV2.value.vipExpiredAt
                  .toString()
                  .split(' ')[0]),
            ],
          ),
          // Tab Section
          const Expanded(child: TabSection()),
        ],
      ),
    );
  }
}
