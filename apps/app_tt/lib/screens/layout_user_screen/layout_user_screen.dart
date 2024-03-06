import 'package:app_tt/screens/layout_user_screen/collection.dart';
import 'package:app_tt/screens/layout_user_screen/favorites.dart';
import 'package:app_tt/screens/layout_user_screen/playrecord.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/user_setting/user_setting_scaffold.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import 'grid_menu.dart';
import 'layout_user_screen_tabbar_header_delegate.dart';
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
              const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/user-bg.webp'),
              ),
              NestedScrollView(
                // controller: scrollController,
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
                        child: const Column(
                          children: [
                            SizedBox(height: 20),
                            // Align(
                            //   // left
                            //   alignment: Alignment.centerLeft,
                            //   child: Row(
                            //     children: [
                            //       SizedBox(width: 16),
                            //       Text('100',
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 17,
                            //           )),
                            //       SizedBox(width: 3),
                            //       Text('個讚數',
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 13,
                            //               color: Color(0xFF73747b))),
                            //       SizedBox(width: 20),
                            //       Text('100',
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 17,
                            //           )),
                            //       SizedBox(width: 3),
                            //       Text('個讚數',
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 13,
                            //               color: Color(0xFF73747b))),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: 30),
                            GridMenu(),
                            SizedBox(height: 25),
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
                    Container(
                        color: Colors.white, child: const PlayRecordPage()),
                    Container(
                        color: Colors.white, child: const FavoritesPage()),
                    Container(
                        color: Colors.white, child: const CollectionPage()),
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
