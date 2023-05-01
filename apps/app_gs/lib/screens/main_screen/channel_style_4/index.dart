// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:app_gs/widgets/header.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_popular_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

const gradiens = {
  1: [Color(0xFF00091A), Color(0xFF45abb1)],
  2: [Color(0xFF00091a), Color(0xFFc08e53)],
  3: [Color(0xFF00091A), Color(0xFFff4545)],
};

class ChannelStyle4 extends StatelessWidget {
  final int channelId;
  ChannelStyle4({Key? key, required this.channelId}) : super(key: key);

  final actorPopularController = Get.put(ActorPopularController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Header(
                text: '人氣女優',
                moreButton: InkWell(
                    onTap: () => {
                          MyRouteDelegate.of(context).push(
                            AppRoutes.actors.value,
                          )
                        },
                    child: const Text(
                      '更多 >',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ))),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),
          Obx(() => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var data = actorPopularController.actors[index];
                    return Container(
                      // height: 277,
                      height: 290,
                      margin: const EdgeInsets.only(bottom: 15),
                      // 圓角10
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SidImage(
                                key: ValueKey(data.actor.coverVertical),
                                sid: data.actor.coverVertical!,
                                // sid: data.vods[0].coverHorizontal!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Opacity(
                                opacity: 0.78,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: index % 3 == 0
                                          ? gradiens[1]!
                                          : index % 3 == 1
                                              ? gradiens[2]!
                                              : gradiens[3]!,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // gradient background
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                    // height 60,width 60,circle image
                                    // SizedBox(
                                    //   width: 60,
                                    //   height: 60,
                                    //   child: ClipRRect(
                                    //     borderRadius: BorderRadius.circular(80),
                                    //     child: SidImage(
                                    //         key: ValueKey(data.actor.photoSid),
                                    //         sid: data.actor.photoSid,
                                    //         width: 60,
                                    //         height: 60,
                                    //         fit: BoxFit.cover),
                                    //   ),
                                    // ),
                                    Container(
                                      padding: const EdgeInsets.all(
                                          1), // Add padding to create the border effect
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFF00B2FF),
                                            Color(0xFFCCEAFF),
                                            Color(0xFF00B2FF),
                                          ],
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          child: SidImage(
                                              key:
                                                  ValueKey(data.actor.photoSid),
                                              sid: data.actor.photoSid,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    // width 10
                                    const SizedBox(width: 10),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data.actor.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                            Text(
                                                '人氣:${data.actor.actorCollectTimes}',
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.5))),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 100,
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () {
                                            MyRouteDelegate.of(context).push(
                                              AppRoutes.actor.value,
                                              args: {
                                                'id': data.actor.id,
                                                'title': data.actor.name,
                                              },
                                            );
                                          },
                                          child: const Text(
                                            '查看全部',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context,
                                        int horizontalIndex) {
                                      var vod = data.vods[horizontalIndex];
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: SizedBox(
                                            width: 119,
                                            height: 159,
                                            child: VideoPreviewWidget(
                                              id: vod.id,
                                              title: vod.title,
                                              coverHorizontal:
                                                  vod.coverHorizontal!,
                                              coverVertical: vod.coverVertical!,
                                              timeLength: vod.timeLength!,
                                              tags: vod.tags!,
                                              videoViewTimes:
                                                  vod.videoViewTimes!,
                                              imageRatio: 119 / 159,
                                            )),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: actorPopularController.actors.length,
                ),
              ))),
        ],
      ),
    );
  }
}
