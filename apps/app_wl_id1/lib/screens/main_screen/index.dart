import 'package:app_wl_id1/screens/main_screen/channels.dart';
import 'package:app_wl_id1/widgets/wave_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';

import 'channel_search_bar.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  final UIController uiController = Get.find<UIController>();

  HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('id1 - HomeMainScreen build');
    return PopScope(
        canPop: false,
        child: MainLayoutLoadingStatusConsumer(
          layoutId: layoutId,
          child: (isLoading) {
            print('id1 - HomeMainScreen build: isLoading: $isLoading');
            if (isLoading) {
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
                    DisplayLayoutTabSearchConsumer(
                        layoutId: layoutId,
                        child: (({required bool displaySearchBar}) =>
                            displaySearchBar
                                ? ChannelSearchBar(
                                    key: Key('channel-search-bar-$layoutId'),
                                  )
                                : Container())),
                    SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 45,
                            child: Obx(() {
                              return uiController.displayHomeNavigationBar.value
                                  ? LayoutTabBar(
                                      layoutId: layoutId,
                                    )
                                  : const SizedBox.shrink();
                            }),
                          )),
                          // DisplayLayoutTabSearch(
                          //   layoutId: layoutId,
                          //   child: ({required bool displaySearchBar}) =>
                          //       displaySearchBar
                          //           ? Container()
                          //           : PopularSearchTitleBuilder(
                          //               child:
                          //                   ({required String searchKeyword}) =>
                          //                       SizedBox(
                          //                 width: 46,
                          //                 height: 55,
                          //                 child: Center(
                          //                     child: Padding(
                          //                   // padding top 5
                          //                   padding:
                          //                       const EdgeInsets.only(top: 6),
                          //                   child: IconButton(
                          //                     icon: const Image(
                          //                       width: 28,
                          //                       height: 28,
                          //                       fit: BoxFit.cover,
                          //                       image: AssetImage(
                          //                           'assets/images/layout_tabbar_search.png'),
                          //                     ),
                          //                     onPressed: () {
                          //                       MyRouteDelegate.of(context)
                          //                           .push(AppRoutes.search,
                          //                               args: {
                          //                             'inputDefaultValue':
                          //                                 searchKeyword,
                          //                             'autoSearch': false
                          //                           });
                          //                     },
                          //                   ),
                          //                 )),
                          //               ),
                          //             ),
                          // )
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ));
          },
        ));
  }
}
