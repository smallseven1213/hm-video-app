import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/ad_window_controller.dart';
import 'package:shared/controllers/block_vod_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/vod.dart';

import '../widgets/channel_area_banner.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

final logger = Logger();

List<List<Vod>> splitVodList(List<Vod> vodList, int chunkSize) {
  List<List<Vod>> chunks = [];
  for (int i = 0; i < vodList.length; i += chunkSize) {
    chunks.add(vodList.sublist(
        i, i + chunkSize > vodList.length ? vodList.length : i + chunkSize));
  }
  return chunks;
}

class VideoByBlockPage extends StatelessWidget {
  final int id;
  final int channelId;
  final String title;
  final int film;
  final scrollController = ScrollController();

  VideoByBlockPage(
      {Key? key,
      required this.id,
      required this.title,
      required this.channelId,
      this.film = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AdWindowController(channelId), tag: channelId.toString());

    final BlockVodController blockVodController =
        BlockVodController(areaId: id, scrollController: scrollController);

    return Scaffold(
        appBar: CustomAppBar(
          title: title,
        ),
        body: Obx(() {
          // 使用 splitVodList 函數將 vodList 按每100個Vod分割成子列表
          List<List<Vod>> vodChunks =
              splitVodList(blockVodController.vodList.value, 100);

          return CustomScrollView(
            controller: blockVodController.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // split every 100 record from blockVodController.vodList
              ...vodChunks
                  .map((e) => SliverBlockWidget(
                        vods: e,
                        channelId: channelId,
                        film: film,
                      ))
                  .toList(),
              if (blockVodController.hasMoreData.value)
                const SliverVideoPreviewSkeletonList(),
              if (!blockVodController.hasMoreData.value)
                const SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          );
        }));
  }
}

class SliverBlockWidget extends StatelessWidget {
  final List<Vod> vods;
  final int channelId;
  final int film;

  const SliverBlockWidget(
      {Key? key, required this.vods, required this.channelId, this.film = 1})
      : super(key: key);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        film: film,
                        displayCoverVertical: film == 2,
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
                              film: film,
                              displayCoverVertical: film == 2,
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
                        image: BannerPhoto.fromJson({
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
