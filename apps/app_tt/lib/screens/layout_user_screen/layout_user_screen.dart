import 'package:app_tt/screens/layout_user_screen/collection.dart';
import 'package:app_tt/screens/layout_user_screen/favorites.dart';
import 'package:app_tt/screens/layout_user_screen/playrecord.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import 'layout_user_screen_tabbar_header_delegate.dart';
import 'user_card.dart';
import 'user_header.dart';

class LayoutUserScreen extends StatefulWidget {
  const LayoutUserScreen({Key? key}) : super(key: key);

  @override
  LayoutUserScreenState createState() => LayoutUserScreenState();
}

class LayoutUserScreenState extends State<LayoutUserScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return UserSettingScaffold(
        onAccountProtectionShownH5: () {},
        onAccountProtectionShown: () {},
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                    ),
                    // UserInfoConsumer(
                    //   child: (info, isVIP, isGuest) => SliverPersistentHeader(
                    //     delegate: UserHeader(info: info, context: context),
                    //     pinned: true,
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: UserInfoConsumer(
                        child: (info, isVIP, isGuest) => UserCard(info: info),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                          children: [
                            Container(
                                width: 60,
                                height: 60,
                                color: Colors.red), // 第一个物件
                            Container(
                                width: 60,
                                height: 60,
                                color: Colors.green), // 第二个物件
                            Container(
                                width: 60,
                                height: 60,
                                color: Colors.blue), // 第三个物件
                            Container(
                                width: 60,
                                height: 60,
                                color: Colors.yellow), // 第四个物件
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate:
                          LayoutUserScreenTabBarHeaderDelegate(_tabController),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    PlayRecordPage(),
                    FavoritesPage(),
                    CollectionPage()
                  ],
                ),
              ),
              const FloatPageBackButton()
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
