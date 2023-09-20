import 'package:app_ra/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';

import '../../widgets/wave_loading.dart';
import 'channel_search_bar.dart';
import 'channels.dart';

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
                        ChannelSearchBar(
                          key: Key('channel-search-bar-$layoutId'),
                        )
                        // DisplayLayoutTabSearchConsumer(
                        //     layoutId: layoutId,
                        //     child: (({required bool displaySearchBar}) =>
                        //         displaySearchBar
                        // ? ChannelSearchBar(
                        //     key:
                        //         Key('channel-search-bar-$layoutId'),
                        //   )
                        //             : Container()))
                      ],
                    )),
                  ],
                ));
          },
        ));
  }
}
