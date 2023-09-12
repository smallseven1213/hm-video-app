import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/services/system_config.dart';

import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';
import '../widgets/user/balance.dart';
import '../widgets/user/info.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<CoinPage> {
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
              const UserBalance(),
            ],
          ),
        ));
  }
}
