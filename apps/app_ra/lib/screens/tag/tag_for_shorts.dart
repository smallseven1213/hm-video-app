import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_tag_vod_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/shorts_type.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/no_data.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';
import '../../widgets/video_preview.dart';

const gridRatio = 128 / 227;

class TagForShorts extends StatefulWidget {
  final int tagId;
  const TagForShorts({
    Key? key,
    required this.tagId,
  }) : super(key: key);

  @override
  TagForShortsState createState() => TagForShortsState();
}

class TagForShortsState extends State<TagForShorts> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final ShortTagVodController vodController = ShortTagVodController(
    tagId: widget.tagId,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScrollView(
          controller: vodController.scrollController,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var vod = vodController.vodList[index];
                  return VideoPreviewWidget(
                      id: vod.id,
                      film: 2,
                      onOverrideRedirectTap: (id) {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.shorts,
                          args: {
                            'type': ShortsType.tag,
                            'videoId': vod.id,
                            'id': widget.tagId
                          },
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
                      displayVideoTimes: false,
                      displayViewTimes: false,
                      videoViewTimes: vod.videoViewTimes!,
                      videoFavoriteTimes: vod.videoFavoriteTimes!);
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
            if (vodController.isListEmpty.value)
              const SliverToBoxAdapter(
                child: NoDataWidget(),
              ),
            if (vodController.displayLoading.value)
              // ignore: prefer_const_constructors
              SliverVideoPreviewSkeletonList(),
            if (vodController.displayNoMoreData.value)
              SliverToBoxAdapter(
                child: ListNoMore(),
              )
          ],
        ));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
