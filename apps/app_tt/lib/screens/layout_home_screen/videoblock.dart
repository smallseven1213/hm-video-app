import 'package:app_tt/screens/layout_home_screen/channel_area_banner.dart';
import 'package:app_tt/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/channel_banner.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/controllers/block_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/base_video_block.dart';
import 'package:shared/widgets/video_block_template/block_1.dart';
import 'package:shared/widgets/video_block_template/block_10.dart';
import 'package:shared/widgets/video_block_template/block_2.dart';
import 'package:shared/widgets/video_block_template/block_3.dart';
import 'package:shared/widgets/video_block_template/block_4.dart';
import 'package:shared/widgets/video_block_template/block_5.dart';
import 'package:shared/widgets/video_block_template/block_6.dart';
import 'package:shared/widgets/video_block_template/block_7.dart';

class VideoBlock extends BaseVideoBlock {
  VideoBlock({Key? key, required Blocks block, required int channelId})
      : super(key: key, block: block, channelId: channelId);

  @override
  _VideoBlockState createState() => _VideoBlockState();
}

class _VideoBlockState extends BaseVideoBlockState<VideoBlock> {
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
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildBanner: (video) => Container(),
          buildFooter: Container(),
        );
      case 2:
        return Block2Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildBanner: (video) => Container(),
          buildFooter: Container(),
        );
      case 3:
        return Block3Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildBanner: (video) => Container(),
          buildFooter: Container(),
        );
      case 4:
        return Block4Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildBanner: (video) => Container(),
          buildFooter: Container(),
        );
      case 5:
        return Block5Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildFooter: Container(),
        );
      case 6:
        return Block6Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildFooter: Container(),
        );
      case 7:
        return Block7Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
        );
      case 10:
        return Block10Widget(
          film: film,
          block: block,
          updateBlock: updateBlock,
          channelId: channelId,
          buildVideoPreview: (video) => VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical!,
              coverHorizontal: video.coverHorizontal!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              title: video.title),
          buildBanner: (video) => Container(),
          buildFooter: Container(),
        );
      default:
        return const SliverToBoxAdapter(child: SizedBox());
    }
  }
}

// final Map<
//         int,
//         Widget Function(
//             Blocks block, Function updateBlock, int channelId, int film)>
//     blockMap = {
  // 0: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     const SliverToBoxAdapter(child: SizedBox()),
  // 1: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block1Widget(
  //         film: film,
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId),
  // 2: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block2Widget(
  //         film: film,
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId),
  // 3: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block3Widget(
  //         film: film,
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId),
  // 4: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block4Widget(
  //         film: film,
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId),
  // 5: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block5Widget(
  //         film: film,
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId),
  // 6: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block6Widget(
  //         film: film,
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId),
  // 7: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block7Widget(
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId,
  //         film: film),
  // 10: (Blocks block, Function updateBlock, int channelId, int film) =>
  //     Block10Widget(
  //         block: block,
  //         updateBlock: updateBlock,
  //         channelId: channelId,
  //         film: film),
// };

// class VideoBlock extends BaseVideoBlock {
//   VideoBlock({Key? key, required Blocks block, required int channelId})
//       : super(key: key, block: block, channelId: channelId);

//   @override
//   _VideoBlockState createState() => _VideoBlockState();
// }

// class _VideoBlockState extends BaseVideoBlockState<VideoBlock> {
//   @override
//   Widget buildBlockWidget(
//       Blocks block, Function updateBlock, int channelId, int film) {
//     // Implement the logic for building the block widget.
//     // You can use different widgets based on the template of the block.
//   }
// }
