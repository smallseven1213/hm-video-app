import 'package:app_ra/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/popular_search_title_builder.dart';

import '../../widgets/wave_loading.dart';
import 'channel_search_bar.dart';
import 'channels.dart';
import 'layout_tab_bar.dart';

class LayoutHomeScreen extends StatelessWidget {
  final int layoutId;
  const LayoutHomeScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: MainLayoutLoadingStatusConsumer(
          layoutId: layoutId,
          child: (isLoading) {
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
                backgroundColor: AppColors.colors[ColorKeys.background],
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
                              DisplayLayoutTabSearchConsumer(
                                layoutId: layoutId,
                                child: ({required bool displaySearchBar}) =>
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
                                                padding: const EdgeInsets.only(
                                                    top: 6),
                                                child: IconButton(
                                                  icon: const Image(
                                                    width: 28,
                                                    height: 28,
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
                                                          'autoSearch': false
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
                    )),
                  ],
                ));
          },
        ));
  }
}
