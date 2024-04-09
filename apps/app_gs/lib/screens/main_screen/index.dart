import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/layout_style_tab_bg_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';

import '../../config/colors.dart';
import '../../widgets/wave_loading.dart';
import 'channel_search_bar.dart';
import 'channels.dart';
import 'floating_button.dart';
import 'layout_tab_bar.dart';

final logger = Logger();

class HomeMainScreen extends StatefulWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  final localStorage = GetStorage();
  final uiController = Get.find<UIController>();
  late BottomNavigatorController bottomNavigatorController;
  bool displayFab = true;

  @override
  void initState() {
    super.initState();
    bottomNavigatorController = Get.find<BottomNavigatorController>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: MainLayoutLoadingStatusConsumer(
          layoutId: widget.layoutId,
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
              ));
            }
            return Obx(() => Scaffold(
                  body: Stack(
                    children: [
                      Channels(
                        key: Key('channels-${widget.layoutId}'),
                        layoutId: widget.layoutId,
                      ),
                      Positioned(
                          child: Column(
                        children: [
                          LayoutStyleTabBgColorConsumer(
                            layoutId: widget.layoutId,
                            child: (({required bool needTabBgColor}) =>
                                Container(
                                  color: needTabBgColor
                                      ? AppColors.colors[ColorKeys.background]
                                      : Colors.transparent,
                                  height:
                                      MediaQuery.of(context).padding.top == 0
                                          ? 8
                                          : MediaQuery.of(context).padding.top,
                                )),
                          ),
                          DisplayLayoutTabSearchConsumer(
                            layoutId: widget.layoutId,
                            child: (({required bool displaySearchBar}) =>
                                displaySearchBar
                                    ? ChannelSearchBar(
                                        key: Key(
                                            'channel-search-bar-${widget.layoutId}'),
                                      )
                                    : Container()),
                          ),
                          uiController.displayHomeNavigationBar.value
                              ? LayoutStyleTabBgColorConsumer(
                                  layoutId: widget.layoutId,
                                  child: (({required bool needTabBgColor}) =>
                                      Container(
                                        color: needTabBgColor
                                            ? AppColors
                                                .colors[ColorKeys.background]
                                            : Colors.transparent,
                                        height: 45,
                                        child: LayoutTabBar(
                                          layoutId: widget.layoutId,
                                        ),
                                      )),
                                )
                              : const SizedBox.shrink()
                        ],
                      )),
                      bottomNavigatorController.activeKey.value ==
                                  HomeNavigatorPathes.layout1 &&
                              bottomNavigatorController.fabLink.isNotEmpty &&
                              bottomNavigatorController.displayFab.value
                          ? FloatingButton(
                              displayFab: displayFab,
                              onFabTap: () => bottomNavigatorController
                                  .setDisplayFab(false),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ));
          },
        ));
  }
}
