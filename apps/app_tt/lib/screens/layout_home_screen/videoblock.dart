import 'package:app_tt/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/base_video_block.dart';
import 'package:shared/widgets/base_video_preview.dart';
import 'package:shared/widgets/video_block_template/block_1.dart';
import 'package:shared/widgets/video_block_template/block_10.dart';
import 'package:shared/widgets/video_block_template/block_2.dart';
import 'package:shared/widgets/video_block_template/block_3.dart';
import 'package:shared/widgets/video_block_template/block_4.dart';
import 'package:shared/widgets/video_block_template/block_5.dart';
import 'package:shared/widgets/video_block_template/block_6.dart';
import 'package:shared/widgets/video_block_template/block_7.dart';

import '../../widgets/video_block_footer.dart';
import '../../widgets/video_preview_in_channel.dart';
import 'channel_area_banner.dart';

class VideoBlock extends BaseVideoBlock {
  const VideoBlock({Key? key, required Blocks block, required int channelId})
      : super(key: key, block: block, channelId: channelId);

  @override
  VideoBlockState createState() => VideoBlockState();
}

class VideoBlockState extends BaseVideoBlockState<VideoBlock> {
  Widget _buildChannelBanner(Vod video) {
    return ChannelAreaBanner(
      image: BannerPhoto.fromJson({
        'id': video.id,
        'url': video.adUrl,
        'photoSid': video.coverHorizontal ?? '',
        'isAutoClose': false,
      }),
    );
  }

  BaseVideoPreviewWidget _buildVideoPreview(
    int film,
    Vod video, {
    hasTags = true,
  }) {
    return ChannelVideoPreviewWidget(
      id: video.id,
      title: video.title,
      tags: video.tags ?? [],
      timeLength: video.timeLength ?? 0,
      coverHorizontal: video.coverHorizontal ?? '',
      coverVertical: video.coverVertical ?? '',
      videoViewTimes: video.videoViewTimes ?? 0,
      videoFavoriteTimes: video.videoFavoriteTimes ?? 0,
      detail: video,
      isEmbeddedAds: block.isEmbeddedAds ?? false,
      displayVideoTimes: film == 1,
      displayViewTimes: film == 1,
      displayVideoFavoriteTimes: film == 2,
      displayCoverVertical: film == 2,
      film: film,
      blockId: block.id,
      hasTags: hasTags,
    );
  }

  @override
  Widget buildBlockWidget(
      Blocks block, Function updateBlock, int channelId, int film) {
    switch (block.template ?? 0) {
      case 0:
        return const SliverToBoxAdapter(child: SizedBox());
      case 1:
        return Block1Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildBanner: _buildChannelBanner,
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      case 2:
        return Block2Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildBanner: _buildChannelBanner,
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      case 3:
        return Block3Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildBanner: _buildChannelBanner,
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      case 4:
        return Block4Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildBanner: _buildChannelBanner,
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      case 5:
        return Block5Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      case 6:
        return Block6Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      case 7:
        return Block7Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          gradientBgTopColor:
              AppColors.colors[ColorKeys.gradientBgTopColor] as Color,
          gradientBgBottomColor:
              AppColors.colors[ColorKeys.gradientBgBottomColor] as Color,
        );
      case 10:
        return Block10Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => _buildVideoPreview(film, video),
          buildBanner: _buildChannelBanner,
          buildFooter: VideoBlockFooter(
            film: film,
            block: block,
            updateBlock: updateBlock,
            channelId: channelId,
          ),
        );
      default:
        return const SliverToBoxAdapter(child: SizedBox());
    }
  }
}
