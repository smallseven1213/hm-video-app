// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:app_wl_ph1/widgets/header.dart';
import 'package:app_wl_ph1/widgets/reload_button.dart';
import 'package:app_wl_ph1/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_popular_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/shorts_type.dart';
import 'package:shared/modules/channel/channe_provider.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../../localization/i18n.dart';
import '../../../widgets/actor_avatar.dart';
import '../../../widgets/channel_banners.dart';
import '../../../widgets/channel_jingang_area.dart';
import '../../../widgets/channel_jingang_area_title.dart';
import '../channel_style_3/tags.dart';

const gradients = {
  1: [Color(0xFF00091A), Color(0xFF45abb1)],
  2: [Color(0xFF00091a), Color(0xFFc08e53)],
  3: [Color(0xFF00091A), Color(0xFFff4545)],
};

class ChannelStyle5 extends StatelessWidget {
  final int channelId;
  final int layoutId;
  ChannelStyle5({Key? key, required this.channelId, required this.layoutId})
      : super(key: key);

  final actorPopularController = Get.put(SupplierPopularController());

  @override
  Widget build(BuildContext context) {
    return DisplayLayoutTabSearchConsumer(
      layoutId: layoutId,
      child: (({required bool displaySearchBar}) {
        return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    (displaySearchBar ? 90 : 50)),
            child: ChannelProvider(
                channelId: channelId,
                widget: Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      ChannelBanners(
                        channelId: channelId,
                      ),
                      ChannelJingangAreaTitle(
                        channelId: channelId,
                      ),
                      ChannelJingangArea(
                        channelId: channelId,
                      ),
                      ChannelTags(
                        channelId: channelId,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 4),
                      ),
                      SliverToBoxAdapter(
                        child: Header(
                            text: I18n.selectedUp,
                            moreButton: GestureDetector(
                                onTap: () => {
                                      MyRouteDelegate.of(context).push(
                                        AppRoutes.suppliers,
                                      )
                                    },
                                child: Text(
                                  '${I18n.more} >',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ))),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 12),
                      ),
                      Obx(() {
                        if (actorPopularController.isError.value) {
                          return SliverFillRemaining(
                            child: ReloadButton(
                              onPressed: () =>
                                  actorPopularController.fetchData(),
                            ),
                          );
                        }
                        return SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  var data =
                                      actorPopularController.actors[index];
                                  return Container(
                                    height: 290,
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SidImage(
                                              key: ValueKey(
                                                  data.supplier.coverVertical),
                                              sid: data.supplier.coverVertical,
                                              // sid: data.vods[0].coverHorizontal!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Opacity(
                                              opacity: 0.78,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: index % 3 == 0
                                                        ? gradients[1]!
                                                        : index % 3 == 1
                                                            ? gradients[2]!
                                                            : gradients[3]!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // gradient background
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.8),
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 5),
                                              // INFO DATA
                                              Row(
                                                children: [
                                                  const SizedBox(width: 8),
                                                  ActorAvatar(
                                                      photoSid: data
                                                          .supplier.photoSid),
                                                  // width 10
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              data.supplier
                                                                  .name,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14)),
                                                          if (data.supplier
                                                                      .description !=
                                                                  null &&
                                                              data
                                                                  .supplier
                                                                  .description!
                                                                  .isNotEmpty)
                                                            Text(
                                                              data.supplier
                                                                      .description ??
                                                                  '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.75),
                                                                  fontSize: 11),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          Text(
                                                              '${I18n.popularity}:${data.supplier.followTimes}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5))),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          MyRouteDelegate.of(
                                                                  context)
                                                              .push(
                                                            AppRoutes.supplier,
                                                            args: {
                                                              'id': data
                                                                  .supplier.id,
                                                            },
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 18),
                                                          child: Text(
                                                            I18n.viewAll,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              // LIST HORIZONTAL
                                              SizedBox(
                                                height: 200,
                                                child: ListView.builder(
                                                  itemCount: data.vods.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int horizontalIndex) {
                                                    var vod = data
                                                        .vods[horizontalIndex];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: SizedBox(
                                                          width: 119,
                                                          height: 159,
                                                          child:
                                                              VideoPreviewWidget(
                                                            id: vod.id,
                                                            title: vod.title,
                                                            film: 2,
                                                            onOverrideRedirectTap:
                                                                (id) {
                                                              MyRouteDelegate.of(
                                                                      context)
                                                                  .push(
                                                                AppRoutes
                                                                    .shorts,
                                                                args: {
                                                                  'type': ShortsType
                                                                      .supplier,
                                                                  'videoId':
                                                                      vod.id,
                                                                  'id': data
                                                                      .supplier
                                                                      .id,
                                                                },
                                                              );
                                                            },
                                                            displayCoverVertical:
                                                                true,
                                                            coverHorizontal: vod
                                                                .coverHorizontal!,
                                                            coverVertical: vod
                                                                .coverVertical!,
                                                            timeLength:
                                                                vod.timeLength!,
                                                            tags: vod.tags!,
                                                            videoViewTimes: vod
                                                                .videoViewTimes!,
                                                            videoFavoriteTimes:
                                                                vod.videoFavoriteTimes!,
                                                            imageRatio:
                                                                119 / 159,
                                                            displayVideoTimes:
                                                                false,
                                                            displayViewTimes:
                                                                false,
                                                            displayVideoFavoriteTimes:
                                                                false,
                                                          )),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: ClipPath(
                                            clipper:
                                                CustomClipperWithRoundedCorners(),
                                            child: GestureDetector(
                                              onTap: () =>
                                                  MyRouteDelegate.of(context)
                                                      .push(
                                                AppRoutes.supplier,
                                                args: {
                                                  'id': data.supplier.id,
                                                },
                                              ),
                                              child: Container(
                                                color: const Color(0xfff32a2a),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 9,
                                                      vertical: 4),
                                                  child: Text(
                                                    '${data.supplier.containVideos}${I18n.numberOfVideos}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                childCount:
                                    actorPopularController.actors.length,
                              ),
                            ));
                      }),
                    ],
                  ),
                )));
      }),
    );
  }
}

class CustomClipperWithRoundedCorners extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 开始画左上角
    path.moveTo(0, 0);

    // 画到右上角，并添加圆角
    path.lineTo(size.width - 10, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 10);

    // 画到右下角
    path.lineTo(size.width, size.height);

    // 画到左下角，并添加圆角
    path.lineTo(10, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 10);

    // 完成路径
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
