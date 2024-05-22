import 'package:app_wl_cn1/widgets/custom_app_bar.dart';
import 'package:app_wl_cn1/widgets/channel_area_banner.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ad_window_controller.dart';
import 'package:shared/controllers/block_vod_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/vod.dart';

import '../widgets/list_no_more.dart';
import '../widgets/no_data.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

List<List<Vod>> splitVodList(List<Vod> vodList, int chunkSize) {
  List<List<Vod>> chunks = [];
  for (int i = 0; i < vodList.length; i += chunkSize) {
    chunks.add(vodList.sublist(
        i, i + chunkSize > vodList.length ? vodList.length : i + chunkSize));
  }
  return chunks;
}

class VideoByBlockPage extends StatefulWidget {
  final int blockId;
  final int channelId;
  final String title;
  final int film;

  const VideoByBlockPage(
      {Key? key,
      required this.blockId,
      required this.title,
      required this.channelId,
      this.film = 1})
      : super(key: key);

  @override
  VideoByBlockPageState createState() => VideoByBlockPageState();
}

class VideoByBlockPageState extends State<VideoByBlockPage> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Get.put(AdWindowController(widget.channelId),
        tag: widget.channelId.toString());

    final BlockVodController blockVodController = BlockVodController(
        areaId: widget.blockId, scrollController: scrollController);

    return Scaffold(
        appBar: CustomAppBar(
          title: widget.title,
        ),
        body: Obx(() {
          // 使用 splitVodList 函数将 vodList 按每100个Vod分割成子列表
          List<List<Vod>> vodChunks =
              splitVodList(blockVodController.vodList, 100);

          return CustomScrollView(
            controller: blockVodController.scrollController,
            physics: kIsWeb ? null : const BouncingScrollPhysics(),
            slivers: [
              // split every 100 record from blockVodController.vodList
              ...vodChunks
                  .map((e) => SliverBlockWidget(
                        vods: e,
                        channelId: widget.channelId,
                        blockId: widget.blockId,
                        film: widget.film,
                      ))
                  .toList(),
              if (blockVodController.isListEmpty.value)
                const SliverToBoxAdapter(
                  child: NoDataWidget(),
                ),
              if (blockVodController.displayLoading.value)
                // ignore: prefer_const_constructors
                SliverVideoPreviewSkeletonList(),
              if (blockVodController.displayNoMoreData.value)
                SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          );
        }));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class SliverBlockWidget extends StatelessWidget {
  final List<Vod> vods;
  final int channelId;
  final int film;
  final int blockId;

  const SliverBlockWidget({
    Key? key,
    required this.vods,
    required this.channelId,
    required this.blockId,
    this.film = 1,
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
                        blockId: blockId,
                        displayVideoTimes: film == 1,
                        displayViewTimes: film == 1,
                        displayCoverVertical: film == 2,
                        videoFavoriteTimes: vods[index * 2].videoFavoriteTimes!,
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
                              blockId: blockId,
                              displayVideoTimes: film == 1,
                              displayViewTimes: film == 1,
                              displayCoverVertical: film == 2,
                              videoFavoriteTimes:
                                  vods[index * 2 + 1].videoFavoriteTimes!,
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
                if (index > 0 &&
                    (index + 1) % 3 == 0 &&
                    index != vods.length - 1 &&
                    adWindowController.data.value.areaBanners.isNotEmpty)
                  Obx(() {
                    var bannerIndex = (index / 3 - 1).ceil() %
                        (adWindowController.data.value.areaBanners.length);

                    var data =
                        adWindowController.data.value.areaBanners[bannerIndex];

                    return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ChannelAreaBanner(
                            image: BannerPhoto.fromJson({
                          'id': data.id,
                          'url': data.url,
                          'photoSid': data.photoSid,
                          'isAutoClose': false,
                        })));
                  }),
              ],
            );
          },
          childCount: (vods.length / 2).ceil(),
        ),
      ),
    );
  }
}
