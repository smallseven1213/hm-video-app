import 'package:app_ra/screens/layout_home_screen/block_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';
import '../../widgets/user/balance.dart';
import '../../widgets/user/info.dart';
import 'banner.dart';
import 'grid_menu.dart';
import 'list_menu.dart';

class LayoutUserScreen extends StatefulWidget {
  const LayoutUserScreen({Key? key}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<LayoutUserScreen> {
  final systemConfigController = Get.find<SystemConfigController>();

  @override
  Widget build(BuildContext context) {
    return UserSettingScaffold(
        onAccountProtectionShownH5: () {
          showConfirmDialog(
            context: context,
            title: '提示',
            message: '為保持您的帳號，請先註冊防止丟失',
            showCancelButton: false,
            onConfirm: () => {},
          );
        },
        onAccountProtectionShown: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: IDCard(),
              );
            },
          );
        },
        child: Scaffold(
          body: CustomScrollView(
            physics: kIsWeb ? null : const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
              ),
              const SliverToBoxAdapter(
                child: UserInfo(),
              ),

              const SliverToBoxAdapter(
                child: UserBalance(),
              ),
              // height 10
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              const GridMenu(),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              const SliverToBoxAdapter(
                  child: Padding(
                // padding x 8
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: UserSreenBanner(),
              )),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const SliverToBoxAdapter(
                child: BlockHeader(text: '更多服務'),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              const ListMenu(),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '版本號:${systemConfigController.version.value}',
                      style: const TextStyle(
                          color: Color(0xFFFFFFFF), fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
