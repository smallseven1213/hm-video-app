import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/game_block_template/game_template_link.dart';
import 'package:shared/widgets/game_block_template/tag.dart';
import 'package:shared/widgets/video_collection_times.dart';
import 'package:shared/widgets/video/view_times.dart';
import 'package:shared/widgets/video/video_time.dart';

import '../config/colors.dart';

const kCardBgColor = Color(0xff02275C);

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final int duration;
  final bool hasRadius;
  final int? videoCollectTimes;
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;

  const ViewInfo({
    Key? key,
    required this.viewCount,
    required this.duration,
    required this.hasRadius,
    this.displayVideoCollectTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.videoCollectTimes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> infoItems = [];

    if (displayViewTimes == true) {
      infoItems.add(ViewTimes(times: viewCount));
    }

    if (displayVideoTimes == true) {
      infoItems.add(VideoTime(time: duration));
    }

    if (displayVideoCollectTimes == true) {
      infoItems.add(VideoCollectionTimes(times: videoCollectTimes ?? 0));
    }

    if (infoItems.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: hasRadius
            ? const BorderRadius.vertical(
                bottom: Radius.circular(10),
              )
            : null,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.05, 1.0],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: infoItems,
      ),
    );
  }
}

class GamePreviewWidget extends StatelessWidget {
  final Vod detail;
  bool? displayCoverVertical;
  bool? hasRadius;
  double? imageRatio;

  GamePreviewWidget({
    super.key,
    required this.detail,
    this.displayCoverVertical,
    this.imageRatio,
    this.hasRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GameTemplateLink(
      url: detail.gameUrl,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: hasRadius == true
              ? const BorderRadius.all(Radius.circular(10))
              : null,
          color: kCardBgColor,
          // color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: imageRatio ??
                      (displayCoverVertical == true ? 119 / 179 : 374 / 198),
                  child: const Center(
                    child: Image(
                      image:
                          AssetImage('assets/images/video_preview_loading.png'),
                      width: 102,
                      height: 70,
                    ),
                  ),
                ),
                // 主體
                AspectRatio(
                  aspectRatio: imageRatio ??
                      (displayCoverVertical == true ? 119 / 179 : 374 / 198),
                  child: Image.network(
                    displayCoverVertical == true
                        ? detail.verticalLogo
                        : detail.horizontalLogo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  left: 8,
                  bottom: 8,
                  child: Image(
                    width: 15,
                    height: 17,
                    image: AssetImage('assets/images/play_count.webp'),
                  ),
                ),
              ],
            ),
            Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.name,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              color: AppColors.colors[ColorKeys.videoTitle]!,
                              fontSize: 12,
                            ),
                          ),
                          if (detail.tags!.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            _buildGameTags()
                          ]
                        ],
                      ),
                    ),
                    // add button with text 'Play Now'
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text('Play Now',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTags() {
    return Container(
      width: double.infinity,
      height: 16,
      color: kCardBgColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 水平滚动
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 5.0,
          runSpacing: 5.0,
          clipBehavior: Clip.antiAlias,
          children: detail.tags!
              .map((Tag tag) => TagWidget(
                    tag: tag,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
