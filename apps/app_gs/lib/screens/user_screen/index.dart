import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_navigator_controller.dart';
import 'package:shared/services/system_config.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/header.dart';
import '../../widgets/id_card.dart';
import 'banner.dart';
import 'grid_menu.dart';
import 'info.dart';
import 'list_menu.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final storage = GetStorage();
  final userNavigatorController = Get.find<UserNavigatorController>();

  checkFirstSeen() {
    final accountProtectionShown = storage.read('account-protection-shown');
    if (accountProtectionShown == null) {
      if (kIsWeb) {
        showConfirmDialog(
          context: context,
          title: '提示',
          message: '為保持您的帳號，請先註冊防止丟失',
          showCancelButton: false,
          onConfirm: () {
            storage.write('account-protection-shown', true);
          },
        );
      } else {
        storage.write('account-protection-shown', true);
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
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i('RENDER: UserScreen');
    return WillPopScope(
      onWillPop: () async => false, // HC: 煩死，勿動!!
      child: Obx(
        () => Scaffold(
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
              // height 10
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              GridMenu(items: userNavigatorController.quickLink.value),
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
                child: Header(text: '更多服務'),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              ListMenu(items: userNavigatorController.moreLink.value),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '版本號:${systemConfig.version}',
                      style: const TextStyle(
                          color: Color(0xFFFFFFFF), fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// MediaQuery.of(context).padding.bottom)
