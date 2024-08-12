import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared/controllers/channel_post_controller.dart';
import 'package:shared/controllers/tag_vod_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../widgets/list_no_more.dart';
import '../widgets/sliver_post_grid.dart';
import '../widgets/sliver_vod_grid.dart';

class TagPage extends StatefulWidget {
  final int id;
  final String title;
  final int film;

  const TagPage({
    Key? key,
    required this.id,
    required this.title,
    this.film = 1,
  }) : super(key: key);

  @override
  TagPageState createState() => TagPageState();
}

class TagPageState extends State<TagPage> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final TagVodController vodController;

  @override
  void initState() {
    super.initState();
    vodController = TagVodController(
      tagId: widget.id,
      scrollController: scrollController,
    );
  }

  @override
  void dispose() {
    vodController.dispose();
    if (scrollController.hasClients) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '#${widget.title}',
      ),
      body: widget.film == 3
          ? SliverPostGrid(tagId: widget.id, vertical: false)
          : Obx(
              () {
                if (widget.film == 2) {
                  return SliverVodGrid(
                      isListEmpty: vodController.isListEmpty.value,
                      displayVideoFavoriteTimes: false,
                      videos: vodController.vodList.value,
                      displayNoMoreData: vodController.displayNoMoreData.value,
                      displayLoading: vodController.displayLoading.value,
                      noMoreWidget: ListNoMore(),
                      displayCoverVertical: true,
                      onOverrideRedirectTap: (id) {
                        MyRouteDelegate.of(context).push(
                            AppRoutes.shortsByLocal,
                            args: {'itemId': 3, 'videoId': id});
                      });
                }
                return SliverVodGrid(
                  isListEmpty: vodController.isListEmpty.value,
                  displayVideoFavoriteTimes: false,
                  videos: vodController.vodList.value,
                  displayNoMoreData: vodController.displayNoMoreData.value,
                  displayLoading: vodController.displayLoading.value,
                  noMoreWidget: ListNoMore(),
                  customScrollController: vodController.scrollController,
                );
              },
            ),
    );
  }
}
