import 'package:app_wl_id1/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/header.dart';
import '../../widgets/id_card.dart';
import 'banner.dart';
import 'grid_menu.dart';
import 'info.dart';
import 'list_menu.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final systemConfigController = Get.find<SystemConfigController>();

  @override
  Widget build(BuildContext context) {
    return UserSettingScaffold(
        onAccountProtectionShownH5: () {
          showConfirmDialog(
            context: context,
            title: I18n.hintMessage,
            message: I18n.maintainAccountPleaseRegisterToPreventLoss,
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
              // height 10
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverToBoxAdapter(
                child: Header(
                  text: I18n.recommendedServices,
                  isNormalFontWeight: true,
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
              SliverToBoxAdapter(
                child: Header(
                  text: I18n.moreServices,
                  isNormalFontWeight: true,
                ),
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
                      '${I18n.versionNumber}:${systemConfigController.version.value}',
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
