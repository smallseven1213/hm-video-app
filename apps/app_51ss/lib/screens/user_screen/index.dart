import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/services/system_config.dart';

import 'package:app_51ss/config/colors.dart';
import 'package:app_51ss/widgets/id_card.dart';

import '../../widgets/header.dart';
import '../../utils/show_confirm_dialog.dart';

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
  @override
  Widget build(BuildContext context) {
    return UserSettingScaffold(
        onAccountProtectionShownH5: (setAccountProtectionShownToTrue) {
          showConfirmDialog(
            context: context,
            title: '提示',
            message: '為保持您的帳號，請先註冊防止丟失',
            showCancelButton: false,
            onConfirm: () => setAccountProtectionShownToTrue,
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
              const SliverToBoxAdapter(
                child: UserInfo(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.colors[ColorKeys.primary] as Color,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
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
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: UserScreenBanner(),
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
              const ListMenu(),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '版本號:${systemConfig.version}',
                      style: TextStyle(
                          color: AppColors.colors[ColorKeys.primary],
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
