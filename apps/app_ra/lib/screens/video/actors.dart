import 'package:flutter/material.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/modules/videos/actor_latest_videos_consumer.dart';

import '../../widgets/actor_avatar.dart';
import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';
import '../../widgets/title_header.dart';

class Actors extends StatelessWidget {
  final List<Actor> actors;

  const Actors({super.key, required this.actors});

  Widget buildVideosWidget(String key, vodList, displayLoading,
      displayNoMoreData, isListEmpty, onLoadMore, index) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: SliverVodGrid(
        key: PageStorageKey<String>(key),
        videos: vodList,
        displayLoading: displayLoading,
        displayNoMoreData: displayNoMoreData,
        isListEmpty: isListEmpty,
        noMoreWidget: ListNoMore(),
        displayVideoFavoriteTimes: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: TitleHeader(text: '同演員')),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 44.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              Actor actor = actors[index];
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        children: [
                          // actor info
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                ActorAvatar(
                                  photoSid: actor.photoSid,
                                  width: 44,
                                  height: 44,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  actor.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF939393),
                                  ),
                                ),
                                // close button
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          // actor videos
                          SizedBox(
                            height: 442,
                            child: ActorLatestVideosConsumer(
                              id: actor.id,
                              child: (vodList,
                                      displayLoading,
                                      displayNoMoreData,
                                      isListEmpty,
                                      onLoadMore) =>
                                  buildVideosWidget(
                                      'actor_latest_vod',
                                      vodList,
                                      displayLoading,
                                      displayNoMoreData,
                                      isListEmpty,
                                      onLoadMore,
                                      0),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  children: <Widget>[
                    ActorAvatar(
                      photoSid: actor.photoSid,
                      width: 44,
                      height: 44,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      actor.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF939393),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
