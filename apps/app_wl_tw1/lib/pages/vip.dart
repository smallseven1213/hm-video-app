import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';

import '../screens/vip/tab_section.dart';
import '../widgets/avatar.dart';
import '../widgets/custom_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1320),
      appBar: const CustomAppBar(title: 'VIP會員'),
      body: Column(
        children: [
          // User Profile Section
          _buildUserInfo(),
          // Tab Section
          const Expanded(child: TabSection()),
        ],
      ),
    );
  }
}
