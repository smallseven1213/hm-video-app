import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/videos/video_by_internal_tag_consumer.dart';

import 'package:app_wl_cn1/screens/main_screen/block_header.dart';
import 'package:app_wl_cn1/widgets/sliver_vod_list.dart';

import '../../../localization/i18n.dart';
import '../../../widgets/list_no_more.dart';
import 'video_actor.dart';
import 'app_download_ad.dart';
import 'banner.dart';
import 'video_info.dart';

final logger = Logger();

class NestedTabBarView extends StatefulWidget {
  final Vod videoDetail;
  final String videoUrl;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
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
                    externalId: widget.videoDetail.externalId ?? '',
                    title: widget.videoDetail.title,
                    tags: widget.videoDetail.tags ?? [],
                    timeLength: widget.videoDetail.timeLength ?? 0,
                    actor: widget.videoDetail.actors,
                    publisher: widget.videoDetail.publisher,
                    viewTimes: widget.videoDetail.videoViewTimes ?? 0,
                    videoDetail: widget.videoDetail,
                  )),
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
            if (widget.videoDetail.actors!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
                  child: BlockHeader(text: I18n.actor),
                ),
              ),
            if (widget.videoDetail.actors!.isNotEmpty)
              SliverToBoxAdapter(
                child: VideoActor(actors: widget.videoDetail.actors),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
                child: BlockHeader(text: I18n.videoRecommended),
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
              displayVideoFavoriteTimes: false,
            );
          },
        ),
      ),
    );
  }
}
