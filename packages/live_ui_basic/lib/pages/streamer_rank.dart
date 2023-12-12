import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:live_core/apis/streamer_api.dart';
import 'package:live_core/controllers/streamer_rank_controller.dart';
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
  late StreamerRankController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StreamerRankController(
        rankType: widget.rankType, timeType: widget.timeType));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF242a3d),
        child: Obx(() {
          List<StreamerRank> rankItems = controller.streamerRanks.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TimeFilterBar(),
              Expanded(
                  child: ListView.builder(
                itemCount: rankItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black26, // 背景颜色
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

                        // 如果不是直播，这里可以为空或放置其他组件
                        const Spacer(),

                        ElevatedButton(
                          onPressed: () {
                            // 关注按钮点击事件
                            // TODO: 关注按钮点击事件
                            _streamerApi.followStreamer(rankItems[index].id);
                          },
                          child: Text('關注',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color(0xffae57ff)), // 按钮颜色
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ],
          );
        }));
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
  const TimeFilterBar({super.key});

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
          buildButton('本日', TimeType.today),
          buildButton('週榜', TimeType.thisWeek),
          buildButton('月榜', TimeType.thisMonth),
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

  Widget buildButton(String title, TimeType timeType) {
    final StreamerRankController streamerRankController = Get.find();

    return InkWell(
      onTap: () => setState(() {
        _selectedIndex = timeType.index;
        streamerRankController.fetchData(RankType.income, timeType);
      }),
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
