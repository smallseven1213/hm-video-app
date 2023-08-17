import 'package:app_gs/widgets/shortcard/short_card_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import '../shortcard/index.dart';
import '../wave_loading.dart';
import 'side_info.dart';

final logger = Logger();

class HomeUseShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;
  final String obsKey;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;
  final String videoUrl;

  const HomeUseShortCard({
    Key? key,
    required this.obsKey,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    required this.videoUrl,
    // required this.isFullscreen,
    this.isActive = true,
    this.supportedPlayRecord = true,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  HomeUseShortCardState createState() => HomeUseShortCardState();
}

class HomeUseShortCardState extends State<HomeUseShortCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl.isEmpty) {
      return const WaveLoading();
    }

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          VideoPlayerProvider(
            tag: widget.obsKey,
            autoPlay: kIsWeb ? false : true,
            videoUrl: widget.videoUrl,
            video: widget.shortData,
            videoDetail: Vod(
              widget.shortData.id,
              widget.shortData.title,
              coverHorizontal: widget.shortData.coverHorizontal!,
              coverVertical: widget.shortData.coverVertical!,
              timeLength: widget.shortData.timeLength!,
              tags: widget.shortData.tags!,
              videoViewTimes: widget.shortData.videoViewTimes!,
            ),
            loadingWidget: const WaveLoading(),
            child: (isReady) => ShortCard(
              obsKey: widget.obsKey,
              index: widget.index,
              isActive: widget.isActive,
              id: widget.shortData.id,
              title: widget.shortData.title,
              shortData: widget.shortData,
              toggleFullScreen: widget.toggleFullScreen,
              allowFullsreen: false,
            ),
          ),
          ShortVideoConsumer(
            vodId: widget.id,
            child: ({
              required isLoading,
              required video,
              required videoDetail,
              required videoUrl,
              required controller,
            }) =>
                SideInfo(
              obsKey: widget.obsKey,
              shortData: widget.shortData,
              controller: controller,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(children: [
              ShortVideoConsumer(
                vodId: widget.id,
                child: ({
                  required isLoading,
                  required video,
                  required videoDetail,
                  required videoUrl,
                  required controller,
                }) =>
                    videoDetail != null
                        ? ShortCardInfo(
                            obsKey: widget.obsKey,
                            data: videoDetail,
                            title: widget.title,
                          )
                        : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
            ]),
          ),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
