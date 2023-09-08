import 'package:app_51ss/screens/main_screen/block_header.dart';
import 'package:app_51ss/widgets/sliver_vod_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/videos/video_by_internal_tag_consumer.dart';

import '../../../widgets/list_no_more.dart';
import 'app_download_ad.dart';
import 'banner.dart';
import 'video_actions.dart';
import 'video_info.dart';

final logger = Logger();

class NestedTabBarView extends StatefulWidget {
  final Vod videoDetail;
  final Vod video;
  final String videoUrl;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
    required this.video,
    required this.videoUrl,
  }) : super(key: key);

  @override
  NestedTabBarViewState createState() => NestedTabBarViewState();
}

class NestedTabBarViewState extends State<NestedTabBarView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                  child: VideoInfo(
                    videoPlayerController: obsVideoPlayerController,
                    externalId: widget.video.externalId ?? '',
                    title: widget.video.title,
                    tags: widget.video.tags ?? [],
                    timeLength: widget.video.timeLength ?? 0,
                    actor: widget.video.actors,
                    publisher: widget.video.publisher,
                    viewTimes: widget.videoDetail.videoViewTimes ?? 0,
                  )),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: VideoActions(
                  videoDetail: Vod(
                    widget.video.id,
                    widget.video.title,
                    coverHorizontal: widget.video.coverHorizontal!,
                    coverVertical: widget.video.coverVertical!,
                    timeLength: widget.video.timeLength!,
                    tags: widget.video.tags!,
                    videoViewTimes: widget.videoDetail.videoViewTimes!,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                child: AppDownloadAd(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                child: VideoScreenBanner(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16, right: 8, left: 8),
                child: BlockHeader(text: '推薦'),
              ),
            ),
          ];
        },
        body: VideoByInternalTagConsumer(
          excludeId: widget.videoDetail.id.toString(),
          internalTagIds: widget.videoDetail.internalTagIds ?? [],
          child: (videos) {
            return SliverVodList(
              key: const Key('video_by_internal_tag'),
              isListEmpty: videos.isEmpty,
              videos: videos,
              displayNoMoreData: false,
              displayLoading: false,
              noMoreWidget: ListNoMore(),
              displayVideoCollectTimes: false,
            );
          },
        ),
      ),
    );
  }
}
