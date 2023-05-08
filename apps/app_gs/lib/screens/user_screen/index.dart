import 'package:flutter/material.dart';
import 'package:shared/services/system_config.dart';

import '../../widgets/header.dart';
import 'ad.dart';
import 'banner.dart';
import 'grid_menu.dart';
import 'info.dart';
import 'list_menu.dart';

final systemConfig = SystemConfig();

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('RENDER: UserScreen');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
            GridMenu(),
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
            const ListMenu(),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '版本號:${systemConfig.version}',
                    style:
                        const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MediaQuery.of(context).padding.bottom)
