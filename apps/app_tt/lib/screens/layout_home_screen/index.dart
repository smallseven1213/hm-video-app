import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/popular_search_title_builder.dart';

import '../../widgets/loading_animation.dart';
import 'channel_search_bar.dart';
import 'channels.dart';
import 'layout_tab_bar.dart';

class LayoutHomeScreen extends StatelessWidget {
  final int layoutId;
  final uiController = Get.find<UIController>();

  LayoutHomeScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: MainLayoutLoadingStatusConsumer(
          layoutId: layoutId,
          child: (isLoading) {
            if (isLoading) {
              return Scaffold(
                body: Center(
                  child: LoadingAnimation(),
                ),
              );
            }
            return Scaffold(
                backgroundColor: const Color(0xFFf0f0f0),
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
                        Obx(
                          () => uiController.displayChannelTab.value
                              ? SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                            height: 45,
                                            child: LayoutTabBar(
                                              layoutId: layoutId,
                                            )),
                                      ),
                                      DisplayLayoutTabSearchConsumer(
                                        layoutId: layoutId,
                                        child: (
                                                {required bool
                                                    displaySearchBar}) =>
                                            displaySearchBar
                                                ? Container()
                                                : PopularSearchTitleBuilder(
                                                    child: (
                                                            {required String
                                                                searchKeyword}) =>
                                                        SizedBox(
                                                      width: 46,
                                                      height: 55,
                                                      child: Center(
                                                          child: Padding(
                                                        // padding top 5
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 6),
                                                        child: IconButton(
                                                          icon:
                                                              SvgPicture.asset(
                                                            'assets/svgs/ic-search.svg',
                                                            width: 16,
                                                            height: 16,
                                                            theme: const SvgTheme(
                                                                currentColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 24),
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Colors.grey,
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          onPressed: () {
                                                            MyRouteDelegate.of(
                                                                    context)
                                                                .push(
                                                                    AppRoutes
                                                                        .search,
                                                                    args: {
                                                                  'inputDefaultValue':
                                                                      searchKeyword,
                                                                  'autoSearch':
                                                                      false
                                                                });
                                                          },
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        DisplayLayoutTabSearchConsumer(
                            layoutId: layoutId,
                            child: (({required bool displaySearchBar}) =>
                                displaySearchBar
                                    ? ChannelSearchBar(
                                        key:
                                            Key('channel-search-bar-$layoutId'),
                                      )
                                    : Container()))
                      ],
                    ))
                  ],
                ));
          },
        ));
  }
}
