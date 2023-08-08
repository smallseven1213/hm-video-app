import 'package:app_gs/widgets/button.dart';
import 'package:shared/widgets/channe_provider.dart';
import 'package:shared/widgets/display_layout_tab_search.dart';
import 'package:shared/widgets/refresh_list.dart';
import 'package:app_gs/widgets/reload_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:app_gs/widgets/video_list_loading_text.dart';

import '../../../widgets/channel_banners.dart';
import '../../../widgets/channel_jingang_area.dart';
import '../../../widgets/channel_skelton.dart';
import '../../../widgets/header.dart';
import '../videoblock.dart';

final logger = Logger();

class ChannelStyle1 extends StatefulWidget {
  final int channelId;
  final int layoutId;

  const ChannelStyle1(
      {Key? key, required this.channelId, required this.layoutId})
      : super(key: key);

  @override
  ChannelStyle1State createState() => ChannelStyle1State();
}

class ChannelStyle1State extends State<ChannelStyle1>
    with AutomaticKeepAliveClientMixin {
  late ChannelDataController channelDataController;

  @override
  void initState() {
    super.initState();
    channelDataController = Get.find<ChannelDataController>(
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
    return DisplayLayoutTabSearch(
        layoutId: widget.layoutId,
        child: (({required bool displaySearchBar}) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (displaySearchBar ? 90 : 50)),
            child: Obx(() {
              ChannelInfo? channelData =
                  channelDataController.channelData.value;

              if (channelDataController.isError.value) {
                return Center(
                  child: ReloadButton(
                    onPressed: () => channelDataController
                        .mutateByChannelId(widget.channelId),
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
                      child: Header(
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
                    sliverBlocks.add(
                        VideoBlock(block: block, channelId: widget.channelId));
                    sliverBlocks.add(const SliverToBoxAdapter(
                      child: SizedBox(height: 10),
                    ));
                  }
                }
                return ChannelProvider(
                    channelId: widget.channelId,
                    widget: RefreshList(
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      loadingWidget: const VideoListLoadingText(),
                      child: CustomScrollView(
                        physics: kIsWeb ? null : const BouncingScrollPhysics(),
                        slivers: [
                          ChannelBanners(
                            channelId: widget.channelId,
                          ),
                          if (channelData.jingang!.title != '')
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Header(
                                    text: channelData.jingang!.title ?? ''),
                              ),
                            ),
                          ChannelJingangArea(
                            channelId: widget.channelId,
                          ),
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
                    ));
              }
            }),
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
