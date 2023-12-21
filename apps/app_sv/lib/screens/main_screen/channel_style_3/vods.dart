import 'dart:async';

import 'package:app_sv/config/colors.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/refresh_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channe_block_vod_controller.dart';
import 'package:shared/widgets/base_video_block_template.dart';

import '../../../widgets/list_no_more.dart';
import '../../../widgets/no_data.dart';
import '../../../widgets/sliver_video_preview_skelton_list.dart';
import '../../../widgets/video_list_loading_text.dart';
import '../../../widgets/video_preview.dart';
import '../../../widgets/channel_area_banner.dart';
import '../reload_button.dart';

class Vods extends StatefulWidget {
  final int areaId;
  final int? templateId;
  final bool isActive;

  const Vods({
    Key? key,
    required this.areaId,
    this.templateId = 3,
    this.isActive = false,
  }) : super(key: key);

  @override
  VodsState createState() => VodsState();
}

class VodsState extends State<Vods> {
  ScrollController? _scrollController;
  ChannelBlockVodController? vodController;
  Timer? _debounceTimer;
  bool isRefreshing = false;

  void _scrollListener() {
    if (isRefreshing) return;
    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 30) {
      debounce(
        fn: () => vodController!.loadMoreData(),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = PrimaryScrollController.of(context);
    _scrollController!.addListener(_scrollListener);

    vodController ??= ChannelBlockVodController(
      areaId: widget.areaId,
      scrollController: _scrollController!,
      autoDisposeScrollController: false,
      hasLoadMoreEventWithScroller: false,
    );
  }

  @override
  void didUpdateWidget(covariant Vods oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _scrollController?.addListener(_scrollListener);
      } else {
        _scrollController?.removeListener(_scrollListener);
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    vodController?.dispose();
    _scrollController?.removeListener(_scrollListener);
    // _scrollController?.dispose();
    super.dispose();
  }

  void debounce({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  void _onRefresh() async {
    setState(() {
      isRefreshing = true;
    });
    vodController!.reset();
    vodController!.pullToRefresh();
  }

  @override
  Widget build(BuildContext context) {
    if (vodController == null) {
      // The controller is not ready yet.
      return const SizedBox();
    }
    return Obx(
      () {
        return RefreshList(
          onRefresh: _onRefresh,
          onRefreshEnd: () {
            setState(() {
              isRefreshing = false;
            });
          },
          loadingWidget: const VideoListLoadingText(),
          loadingText: Text(
            '內容已更新',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.colors[ColorKeys.textSecondary],
            ),
          ),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: BaseVideoBlockTemplate(
                  film: vodController!.film.value,
                  templateId: widget.templateId ?? 3,
                  areaId: widget.areaId,
                  // ignore: invalid_use_of_protected_member
                  vods: vodController!.vodList.value,
                  buildBanner: (video) => ChannelAreaBanner(
                    image: BannerPhoto.fromJson({
                      'id': video.id,
                      'url': video.adUrl ?? '',
                      'photoSid': video.coverHorizontal ?? '',
                      'isAutoClose': false,
                    }),
                  ),
                  buildVideoPreview: (video) => VideoPreviewWidget(
                    hasTags: false,
                    id: video.id,
                    title: video.title,
                    tags: video.tags ?? [],
                    timeLength: video.timeLength ?? 0,
                    coverHorizontal: video.coverHorizontal ?? '',
                    coverVertical: video.coverVertical ?? '',
                    videoViewTimes: video.videoViewTimes ?? 0,
                    videoCollectTimes: video.videoCollectTimes ?? 0,
                    detail: video,
                    isEmbeddedAds: true,
                    blockId: widget.areaId,
                    film: vodController!.film.value,
                    displayVideoCollectTimes: false,
                    displayCoverVertical: vodController!.film.value == 2,
                  ),
                ),
              ),
              if (vodController?.isError.value == true)
                SliverFillRemaining(
                  child: Center(
                    child: ReloadButton(
                      onPressed: () {
                        _onRefresh();
                      },
                    ),
                  ),
                ),
              if (vodController?.isError.value == false &&
                  vodController!.isListEmpty.value)
                const SliverToBoxAdapter(
                  child: NoDataWidget(),
                ),
              if (vodController!.displayLoading.value && !isRefreshing)
                // ignore: prefer_const_constructors
                SliverVideoPreviewSkeletonList(),
              if (vodController!.displayNoMoreData.value)
                SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          ),
        );
      },
    );
  }
}
