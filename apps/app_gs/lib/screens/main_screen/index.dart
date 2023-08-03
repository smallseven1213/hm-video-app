import 'package:app_gs/screens/main_screen/channels.dart';
import 'package:app_gs/widgets/wave_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/display_layout_tab_search.dart';
import 'package:shared/widgets/popular_search_title_builder.dart';

import 'channel_search_bar.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<LayoutController>(
        tag: 'layout$layoutId',
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Scaffold(
                body: Center(
                  child: WaveLoading(
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                    duration: Duration(milliseconds: 1000),
                    size: 17,
                    itemCount: 3,
                  ),
                ),
              );
            }
            return Scaffold(
                body: Stack(
              children: [
                Channels(
                  key: Key('channels-$layoutId'),
                  layoutId: layoutId,
                ),
                Positioned(
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  height: 45,
                                  child: LayoutTabBar(
                                    layoutId: layoutId,
                                  ))),
                          DisplayLayoutTabSearch(
                            layoutId: layoutId,
                            child: ({required bool displaySearchBar}) =>
                                displaySearchBar
                                    ? Container()
                                    : PopularSearchTitleBuilder(
                                        child:
                                            ({required String searchKeyword}) =>
                                                SizedBox(
                                          width: 36,
                                          height: 65,
                                          child: Center(
                                              child: Padding(
                                            // padding top 5
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: IconButton(
                                              icon: const Image(
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/layout_tabbar_search.png'),
                                              ),
                                              onPressed: () {
                                                MyRouteDelegate.of(context)
                                                    .push(AppRoutes.search,
                                                        args: {
                                                      'inputDefaultValue':
                                                          searchKeyword,
                                                      'autoSearch': true
                                                    });
                                              },
                                            ),
                                          )),
                                        ),
                                      ),
                          )
                        ],
                      ),
                    ),
                    DisplayLayoutTabSearch(
                        layoutId: layoutId,
                        child: (({required bool displaySearchBar}) =>
                            displaySearchBar
                                ? ChannelSearchBar(
                                    key: Key('channel-search-bar-$layoutId'),
                                  )
                                : Container()))
                  ],
                )),
              ],
            ));
          });
        },
      ),
    );
  }
}
