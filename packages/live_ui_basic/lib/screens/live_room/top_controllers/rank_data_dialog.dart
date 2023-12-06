import 'package:flutter/material.dart';
import 'package:live_core/models/room.dart';
import 'package:live_core/models/room_rank.dart';

import 'rank_number.dart';

class RankDataDialog extends StatefulWidget {
  final RoomRank? roomRank;

  RankDataDialog({Key? key, this.roomRank}) : super(key: key);

  @override
  _RankDataDialogState createState() => _RankDataDialogState();
}

class _RankDataDialogState extends State<RankDataDialog>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget buildTabView(List<RankItem> rankItems) {
    return ListView.builder(
      itemCount: rankItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RankNumber(
              number: index + 1,
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                image: DecorationImage(
                  image: NetworkImage(rankItems[index].avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(rankItems[index].nickname,
                  style: TextStyle(fontSize: 11, color: Colors.white)),
            ),
            Expanded(
              flex: 1,
              child: Text(rankItems[index].amount.toString(),
                  style: TextStyle(fontSize: 11, color: Colors.white)),
            )
          ],
        );
        // return ListTile(
        //   leading: Image.network(rankItems[index].avatar),
        //   title: Text(rankItems[index].nickname),
        //   subtitle: Text('Amount: ${rankItems[index].amount}'),
        //   trailing: Text('#${rankItems[index].rank}'),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomRank = widget.roomRank;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 150,
        child: Column(
          children: [
            SizedBox(
              height: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      'packages/live_ui_basic/assets/images/rank_diamondlist.webp',
                      width: 12,
                      height: 12),
                  const Text(
                    "鑽石排行榜",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20, // 设置 TabBar 的高度为 15px
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: TextStyle(fontSize: 9), // 设置 Tab 文字大小
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: Colors.grey),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                tabs: [
                  Tab(text: '本場直播'),
                  Tab(text: '今日'),
                  Tab(text: '7日'),
                  Tab(text: '30日'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildTabView(roomRank?.rank ?? []),
                  buildTabView(roomRank?.rank1 ?? []),
                  buildTabView(roomRank?.rank7 ?? []),
                  buildTabView(roomRank?.rank30 ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
