import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:live_core/controllers/user_follows_controller.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_core/widgets/streamer_rank_provider.dart';

import 'package:live_core/models/streamer.dart';
import 'package:live_core/models/streamer_rank.dart';
import 'package:live_ui_basic/widgets/rank_number.dart';

import '../localization/live_localization_delegate.dart';

class StreamerRankPage extends StatefulWidget {
  const StreamerRankPage({Key? key}) : super(key: key);

  @override
  StreamerRankPageState createState() => StreamerRankPageState();
}

class StreamerRankPageState extends State<StreamerRankPage> {
  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF242a3d),
          title: Text(localizations.translate('host_ranking'),
              style: const TextStyle(fontSize: 14)),
          bottom: TabBar(
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: localizations.translate('comprehensive')),
              Tab(text: localizations.translate('popularity')),
              Tab(text: localizations.translate('newcomer')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RankingScreen(rankType: RankType.income, timeType: TimeType.today),
            RankingScreen(
                rankType: RankType.popularity, timeType: TimeType.today),
            RankingScreen(
                rankType: RankType.liveTimes, timeType: TimeType.today),
          ],
        ),
      ),
    );
  }
}

class RankingScreen extends StatefulWidget {
  final RankType rankType;
  final TimeType timeType;

  const RankingScreen({
    Key? key,
    required this.rankType,
    required this.timeType,
  }) : super(key: key);
  @override
  RankingScreenState createState() => RankingScreenState();
}

class RankingScreenState extends State<RankingScreen> {
  final userFollowsController = Get.find<UserFollowsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Container(
      color: const Color(0xFF242a3d),
      child: StreamerRankProvider(
          rankType: widget.rankType,
          timeType: widget.timeType,
          child: (List<StreamerRank> rankItems, updateCallback) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeFilterBar(
                  rankType: widget.rankType,
                  timeType: widget.timeType,
                  updateCallback: updateCallback,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: rankItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.black26,
                      child: Row(
                        children: <Widget>[
                          RankNumber(
                            number: index + 1,
                            width: 32,
                            height: 20,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: LiveImage(
                              base64Url: rankItems[index].avatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(rankItems[index].nickname,
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(width: 16.0),
                          rankItems[index].isLiving
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0),
                                    color: const Color(0xffe6cf5fb0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 2.0),
                                  child: const Text('LIVE',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                )
                              : Container(),
                          const Spacer(),
                          Obx(() {
                            var isFollowed = userFollowsController.follows
                                .any((e) => e.id == rankItems[index].id);
                            return ElevatedButton(
                              onPressed: () {
                                Streamer streamer = Streamer(
                                    id: rankItems[index].id,
                                    nickname: rankItems[index].nickname);
                                if (isFollowed) {
                                  userFollowsController.unfollow(streamer.id);
                                } else {
                                  userFollowsController.follow(streamer);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    isFollowed
                                        ? const Color(0xff7b7b7b)
                                        : const Color(0xffae57ff)),
                              ),
                              child: Text(
                                  isFollowed
                                      ? localizations.translate('followed')
                                      : localizations.translate('follow'),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                )),
              ],
            );
          }),
    );
  }
}

class Anchor {
  final String name;
  final String id;
  final String avatar;
  final bool isLive;

  Anchor(this.name, this.id, this.avatar, this.isLive);
}

class TimeFilterBar extends StatefulWidget {
  final RankType rankType;
  final TimeType timeType;
  final Function(RankType, TimeType) updateCallback;

  const TimeFilterBar({
    super.key,
    required this.rankType,
    required this.timeType,
    required this.updateCallback,
  });

  @override
  TimeFilterBarState createState() => TimeFilterBarState();
}

class TimeFilterBarState extends State<TimeFilterBar> {
  int _selectedIndex = 1; // Initial index of the selected item

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: buildButton(
                    title: localizations.translate('daily_ranking'),
                    timeType: TimeType.today,
                    updateRankList: () =>
                        widget.updateCallback(widget.rankType, TimeType.today),
                  ),
                ),
                Flexible(
                  child: buildButton(
                    title: localizations.translate('weekly_ranking'),
                    timeType: TimeType.thisWeek,
                    updateRankList: () => widget.updateCallback(
                        widget.rankType, TimeType.thisWeek),
                  ),
                ),
                Flexible(
                  child: buildButton(
                    title: localizations.translate('monthly_ranking'),
                    timeType: TimeType.thisMonth,
                    updateRankList: () => widget.updateCallback(
                        widget.rankType, TimeType.thisMonth),
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(
                maxWidth: 120), // Set a max width for the text
            child: Text(
              localizations.translate('data_updates_every_hour'),
              overflow:
                  TextOverflow.ellipsis, // Use ellipsis to handle overflow
              maxLines: 2, // Allow up to two lines
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xff7b7b7b),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required String title,
    required TimeType timeType,
    required Function updateRankList,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = timeType.index;
        });
        updateRankList();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.only(bottom: 2, left: 5, right: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedIndex == timeType.index
                  ? const Color(0xff7b7b7b)
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == timeType.index
                ? Colors.white
                : const Color(0xff7b7b7b),
          ),
        ),
      ),
    );
  }
}
