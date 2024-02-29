import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:live_core/apis/streamer_api.dart';
import 'package:live_core/controllers/user_follows_controller.dart';
import 'package:live_core/widgets/streamer_rank_provider.dart';

import 'package:live_core/models/streamer.dart';
import 'package:live_core/models/streamer_rank.dart';
import 'package:live_ui_basic/widgets/rank_number.dart';

class StreamerRankPage extends StatefulWidget {
  const StreamerRankPage({Key? key}) : super(key: key);

  @override
  _StreamerRankPageState createState() => _StreamerRankPageState();
}

class _StreamerRankPageState extends State<StreamerRankPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF242a3d),
          title: const Text('主播排行', style: TextStyle(fontSize: 14)),
          bottom: const TabBar(
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: '綜合'),
              Tab(text: '人氣'),
              Tab(text: '新人'),
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

final _streamerApi = StreamerApi();

class RankingScreen extends StatefulWidget {
  final RankType rankType;
  final TimeType timeType;

  const RankingScreen({
    Key? key,
    required this.rankType,
    required this.timeType,
  }) : super(key: key);
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final userFollowsController = Get.find<UserFollowsController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(rankItems[index].avatar),
                                fit: BoxFit.cover,
                              ),
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
                              child: Text(isFollowed ? '已關注' : '關注',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    isFollowed
                                        ? const Color(0xff7b7b7b)
                                        : const Color(0xffae57ff)),
                              ),
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
  _TimeFilterBarState createState() => _TimeFilterBarState();
}

class _TimeFilterBarState extends State<TimeFilterBar> {
  int _selectedIndex = 1; // Initial index of the selected item

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildButton(
            title: '日榜',
            timeType: TimeType.today,
            updateRankList: () =>
                widget.updateCallback(widget.rankType, TimeType.today),
          ),
          buildButton(
            title: '週榜',
            timeType: TimeType.thisWeek,
            updateRankList: () =>
                widget.updateCallback(widget.rankType, TimeType.thisWeek),
          ),
          buildButton(
            title: '月榜',
            timeType: TimeType.thisMonth,
            updateRankList: () =>
                widget.updateCallback(widget.rankType, TimeType.thisMonth),
          ),
          const Expanded(
              child: Text(
            '數據每小時更新',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xff7b7b7b),
              fontSize: 10,
            ),
          ))
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
        margin: const EdgeInsets.only(right: 10),
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
