import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/short_tag_vod_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../widgets/list_no_more.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

const gridRatio = 128 / 227;
final logger = Logger();

class SupplierTagVideoPage extends StatelessWidget {
  final int tagId;
  final String tagName;

  const SupplierTagVideoPage({
    Key? key,
    required this.tagId,
    required this.tagName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final vodController =
        ShortTagVodController(tagId: tagId, scrollController: scrollController);
    return Scaffold(
      appBar: CustomAppBar(title: '#$tagName'),
      body: Obx(() => CustomScrollView(
            controller: vodController.scrollController,
            slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var vod = vodController.vodList.value[index];
                    return VideoPreviewWidget(
                        id: vod.id,
                        film: 2,
                        onOverrideRedirectTap: () {
                          MyRouteDelegate.of(context).push(
                            AppRoutes.shortsByTag.value,
                            args: {'videoId': vod.id, 'tagId': tagId},
                          );
                        },
                        hasRadius: false,
                        hasTitle: false,
                        imageRatio: gridRatio,
                        displayCoverVertical: true,
                        coverVertical: vod.coverVertical!,
                        coverHorizontal: vod.coverHorizontal!,
                        timeLength: vod.timeLength!,
                        hasTags: false,
                        tags: vod.tags!,
                        title: vod.title,
                        videoViewTimes: vod.videoViewTimes!,
                        videoCollectTimes: vod.videoCollectTimes!);
                  },
                  childCount: vodController.vodList.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: gridRatio,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
              ),
              if (vodController.hasMoreData.value)
                const SliverVideoPreviewSkeletonList(),
              if (!vodController.hasMoreData.value)
                SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          )),
    );
  }
}
