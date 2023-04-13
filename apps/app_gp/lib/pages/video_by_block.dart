import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/ad_window_controller.dart';
import 'package:shared/controllers/block_videos_controller.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/vod.dart';

import '../widgets/channel_area_banner.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

final logger = Logger();

class VideoByBlockPage extends StatelessWidget {
  final int id;
  final int channelId;
  final String title;

  const VideoByBlockPage({
    Key? key,
    required this.id,
    required this.title,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BlockVideosController blockVideosController =
        Get.put(BlockVideosController(id), tag: id.toString());
    Get.put(AdWindowController(channelId), tag: channelId.toString());

    final ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        blockVideosController.fetchMoreVideos();
      }
    });

    return Scaffold(
        appBar: CustomAppBar(
          title: title,
        ),
        body: Obx(() => CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                ...blockVideosController.blocks
                    .map((e) =>
                        SliverBlockWidget(vods: e.vods, channelId: channelId))
                    .toList(),
              ],
            )));
  }
}

class SliverBlockWidget extends StatelessWidget {
  final List<Vod> vods;
  final int channelId;
  const SliverBlockWidget({
    Key? key,
    required this.vods,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdWindowController adWindowController =
        Get.find<AdWindowController>(tag: channelId.toString());
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: VideoPreviewWidget(
                        id: vods[index * 2].id,
                        title: vods[index * 2].title,
                        coverHorizontal: vods[index * 2].coverHorizontal!,
                        coverVertical: vods[index * 2].coverVertical!,
                        timeLength: vods[index * 2].timeLength!,
                        tags: vods[index * 2].tags!,
                        videoViewTimes: vods[index * 2].videoViewTimes!,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    index * 2 + 1 < vods.length
                        ? Expanded(
                            child: VideoPreviewWidget(
                              id: vods[index * 2 + 1].id,
                              title: vods[index * 2 + 1].title,
                              coverHorizontal:
                                  vods[index * 2 + 1].coverHorizontal!,
                              coverVertical: vods[index * 2 + 1].coverVertical!,
                              timeLength: vods[index * 2 + 1].timeLength!,
                              tags: vods[index * 2 + 1].tags!,
                              videoViewTimes:
                                  vods[index * 2 + 1].videoViewTimes!,
                            ),
                          )
                        : const Expanded(
                            child: SizedBox(),
                          )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (index > 0 && (index + 1) % 3 == 0)
                  Obx(() {
                    var bannerIndex = (index / 3 - 1).ceil() %
                        (adWindowController.data.value.channelBanners.length);

                    var data = adWindowController
                        .data.value.channelBanners[bannerIndex];

                    return ChannelAreaBanner(
                        image: BannerImage.fromJson({
                      'id': data.id,
                      'url': data.url,
                      'photoSid': data.photoSid,
                      'isAutoClose': false,
                    }));
                  }),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
          childCount: (vods.length / 2).ceil(),
        ),
      ),
    );
  }
}
