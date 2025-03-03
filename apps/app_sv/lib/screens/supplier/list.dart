import 'package:app_sv/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/shorts_type.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/no_data.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';

const gridRatio = 128 / 227;

class SupplierVods extends StatelessWidget {
  final int id;
  final List<Vod> videos;
  final bool displayNoMoreData;
  final bool isListEmpty;
  final bool displayLoading;

  const SupplierVods(
      {Key? key,
      required this.id,
      required this.videos,
      required this.displayNoMoreData,
      required this.isListEmpty,
      required this.displayLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int totalRows = (videos.length / 2).ceil();

      return CustomScrollView(
        controller: PrimaryScrollController.of(context),
        slivers: [
          if (isListEmpty)
            const SliverToBoxAdapter(
              child: NoDataWidget(),
            ),
          if (totalRows > 0)
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: gridRatio,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var vod = videos[index];
                    return VideoPreviewWidget(
                        id: id,
                        onOverrideRedirectTap: (id) {
                          MyRouteDelegate.of(context).push(
                            AppRoutes.shorts,
                            args: {
                              'type': ShortsType.supplier,
                              'videoId': vod.id,
                              'id': id
                            },
                          );
                        },
                        film: 2,
                        hasRadius: false,
                        hasTitle: false,
                        hasTags: false,
                        imageRatio: gridRatio,
                        displayVideoTimes: false,
                        displayViewTimes: false,
                        displayCoverVertical: true,
                        coverVertical: vod.coverVertical!,
                        coverHorizontal: vod.coverHorizontal!,
                        timeLength: vod.timeLength!,
                        tags: vod.tags!,
                        title: vod.title,
                        videoViewTimes: vod.videoViewTimes!,
                        videoFavoriteTimes: vod.videoFavoriteTimes!);
                  },
                  childCount: videos.length,
                ),
              ),
            ),
          // ignore: prefer_const_constructors
          if (displayLoading) SliverVideoPreviewSkeletonList(),
          if (displayNoMoreData)
            SliverToBoxAdapter(
              child: ListNoMore(),
            ),
        ],
      );
    });
  }
}
