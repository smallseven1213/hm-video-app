import 'package:flutter/material.dart';
import 'package:live_core/models/room.dart';
import 'package:live_core/widgets/live_list_provider.dart';
import 'package:live_ui_basic/screens/live/room_item.dart';

class LiveList extends StatelessWidget {
  const LiveList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LiveListProvider(child: (List<Room> rooms) {
      if (rooms.isEmpty) {
        return const SliverToBoxAdapter(
            child: SizedBox.shrink()); // 或者顯示一個加載中的指示器
      }
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 每行顯示兩個項目
          childAspectRatio: 1, // 正方形項目
          crossAxisSpacing: 10, // 水平間隔
          mainAxisSpacing: 10, // 垂直間隔
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => RoomItem(room: rooms[index]),
          childCount: rooms.length,
        ),
      );
    });
  }
}
