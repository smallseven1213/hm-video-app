import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/channel_skelton.dart';
import '../../../widgets/header.dart';
import 'banners.dart';
import 'jingang.dart';
import 'videoblock.dart';

final logger = Logger();

Widget buildTitle(String title) {
  return title == ''
      ? const SizedBox()
      : Column(
          children: [
            Header(text: title),
            const SizedBox(height: 8),
          ],
        );
}

class Channel extends StatefulWidget {
  final int channelId;

  const Channel({Key? key, required this.channelId}) : super(key: key);

  @override
  _ChannelState createState() => _ChannelState();
}

class _ChannelState extends State<Channel> with AutomaticKeepAliveClientMixin {
  late ChannelDataController channelDataController;

  @override
  void initState() {
    super.initState();
    channelDataController = Get.find<ChannelDataController>(
      tag: 'channelId-${widget.channelId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      ChannelInfo? channelData = channelDataController.channelData.value;

      if (channelData == null) {
        return const ChannelSkeleton();
      } else {
        List<Widget> sliverBlocks = [];
        for (var block in channelData.blocks!) {
          sliverBlocks.add(SliverToBoxAdapter(
            child: Header(
              text: '${block.name} [${block.template}]',
              moreButton: block.isMore!
                  ? InkWell(
                      onTap: () => {
                            MyRouteDelegate.of(context).push(
                              AppRoutes.videoByBlock.value,
                              args: {
                                'id': block.id,
                                'title': block.name,
                                'channelId': widget.channelId,
                              },
                            )
                          },
                      child: const Text(
                        '更多 >',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ))
                  : null,
            ),
          ));
          sliverBlocks.add(const SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ));
          sliverBlocks
              .add(VideoBlock(block: block, channelId: widget.channelId));
          sliverBlocks.add(const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: Banners(channelId: widget.channelId)),
            SliverToBoxAdapter(
                child: buildTitle(channelData.jingang!.title ?? '')),
            JingangList(channelId: widget.channelId),
            ...sliverBlocks,
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            )
          ],
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
