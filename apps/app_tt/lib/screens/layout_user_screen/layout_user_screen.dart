import 'package:app_tt/screens/layout_user_screen/collection.dart';
import 'package:app_tt/screens/layout_user_screen/favorites.dart';
import 'package:app_tt/screens/layout_user_screen/playrecord.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import 'layout_user_screen_tabbar_header_delegate.dart';
import 'user_card.dart';
import 'user_grid_menu_button.dart';
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
  final ScrollController scrollController = ScrollController();

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
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              NestedScrollView(
                controller: scrollController,
                // physics: const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: UserHeader(context: context),
                      pinned: true,
                    ),
                    // SliverToBoxAdapter(
                    //   child: UserInfoConsumer(
                    //     child: (info, isVIP, isGuest) => UserCard(info: info),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Align(
                              // left
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  SizedBox(width: 16),
                                  Text('100',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      )),
                                  SizedBox(width: 3),
                                  Text('個讚數',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF73747b))),
                                  SizedBox(width: 20),
                                  Text('100',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      )),
                                  SizedBox(width: 3),
                                  Text('個讚數',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFF73747b))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 水平居中
                              children: [
                                UserGridMenuButton(
                                  iconWidget: SvgPicture.asset(
                                    'svgs/ic-myid.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xFF161823), BlendMode.srcIn),
                                  ),
                                  text: '身份卡',
                                  onTap: () {
                                    _tabController.animateTo(1);
                                  },
                                ),
                                const SizedBox(width: 50),
                                UserGridMenuButton(
                                  iconWidget: SvgPicture.asset(
                                    'svgs/ic-myshare.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xFF161823), BlendMode.srcIn),
                                  ),
                                  text: '推廣分享',
                                  onTap: () {
                                    _tabController.animateTo(1);
                                  },
                                ),
                                const SizedBox(width: 50),
                                UserGridMenuButton(
                                  iconWidget: SvgPicture.asset(
                                    'svgs/ic-myservice.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xFF161823), BlendMode.srcIn),
                                  ),
                                  text: '在線客服',
                                  onTap: () {
                                    _tabController.animateTo(1);
                                  },
                                ),
                                const SizedBox(width: 50),
                                UserGridMenuButton(
                                  iconWidget: SvgPicture.asset(
                                    'svgs/ic-myapp.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xFF161823), BlendMode.srcIn),
                                  ),
                                  text: '應用中心',
                                  onTap: () {
                                    _tabController.animateTo(1);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
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
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  // physics: const BouncingScrollPhysics(),
                  children: [
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
