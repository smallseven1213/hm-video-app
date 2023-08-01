import 'package:app_tt/screens/layout_home_screen/block_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/refresh_list.dart';

import '../../../widgets/button.dart';
import '../../../widgets/channel_skelton.dart';
import '../reload_button.dart';
import '../videoblock.dart';
import 'banners.dart';
import 'jingang.dart';

class ChannelStyle1 extends StatefulWidget {
  final int channelId;

  const ChannelStyle1({Key? key, required this.channelId}) : super(key: key);

  @override
  ChannelStyle1State createState() => ChannelStyle1State();
}

class ChannelStyle1State extends State<ChannelStyle1>
    with AutomaticKeepAliveClientMixin {
  late ChannelDataController channelDataController;

  @override
  void initState() {
    super.initState();
    channelDataController = Get.put(
      ChannelDataController(channelId: widget.channelId),
      tag: 'channelId-${widget.channelId}',
    );
  }

  void _onLoading() async {
    // print('onLoading');
  }

  void _onRefresh() async {
    channelDataController.offset = channelDataController.offset <= 5
        ? channelDataController.offset + 1
        : 1;
    channelDataController.mutateByChannelId(widget.channelId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 90),
      child: Obx(() {
        ChannelInfo? channelData = channelDataController.channelData.value;

        if (channelDataController.isError.value) {
          return Center(
            child: ReloadButton(
              onPressed: () =>
                  channelDataController.mutateByChannelId(widget.channelId),
            ),
          );
        } else if (channelData == null) {
          return const ChannelSkeleton();
        } else {
          List<Widget> sliverBlocks = [];
          for (var block in channelData.blocks!) {
            if (block.quantity != 0 && block.videos!.data!.isNotEmpty) {
              sliverBlocks.add(SliverToBoxAdapter(
                key: Key(
                    'block${block.id}_${widget.channelId}_${channelDataController.offset}'),
                child: BlockHeader(
                  text: block.name ?? '',
                  moreButton: block.isMore!
                      ? InkWell(
                          onTap: () => {
                                if (block.film == 1)
                                  {
                                    MyRouteDelegate.of(context).push(
                                      AppRoutes.videoByBlock,
                                      args: {
                                        'blockId': block.id,
                                        'title': block.name,
                                        'channelId': widget.channelId,
                                      },
                                    )
                                  }
                                else if (block.film == 2)
                                  {
                                    MyRouteDelegate.of(context).push(
                                      AppRoutes.videoByBlock,
                                      args: {
                                        'blockId': block.id,
                                        'title': block.name,
                                        'channelId': widget.channelId,
                                        'film': 2,
                                      },
                                    )
                                  }
                                else if (block.film == 3)
                                  {
                                    MyRouteDelegate.of(context).push(
                                      AppRoutes.videoByBlock,
                                      args: {
                                        'id': block.id,
                                        'title': block.name,
                                        'channelId': widget.channelId,
                                      },
                                    )
                                  }
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
          }
          return RefreshList(
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: CustomScrollView(
              physics: kIsWeb ? null : const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Banners(channelId: widget.channelId),
                )),
                if (channelData.jingang!.title != '')
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:
                          BlockHeader(text: channelData.jingang!.title ?? ''),
                    ),
                  ),
                JingangList(channelId: widget.channelId),
                ...sliverBlocks,
                SliverToBoxAdapter(
                  child: AspectRatio(
                    aspectRatio: 390 / 190,
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Image(
                            image: AssetImage(
                                'assets/images/channel_more_button.webp'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 38,
                            width: 183,
                            child: Button(
                              text: '探索更多內容',
                              onPressed: () {
                                MyRouteDelegate.of(context)
                                    .push(AppRoutes.filter);
                              },
                              type: 'primary',
                              size: 'small',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
