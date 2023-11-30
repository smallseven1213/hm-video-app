import 'package:flutter/material.dart';
import 'package:live_core/models/room_rank.dart';

class RankList extends StatelessWidget {
  final RoomRank? roomRank;

  RankList({Key? key, this.roomRank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (roomRank == null) {
      return Container();
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: roomRank!.rank.length,
      itemBuilder: (context, index) {
        RankItem item = roomRank!.rank[index];
        return Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.all(5),
          color: Colors.blue, // 或者您想要的任何颜色
          // 可以在这里添加更多的样式或内容
        );
      },
    );
  }
}
