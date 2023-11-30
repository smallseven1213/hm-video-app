import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_ui_basic/screens/live/room_item.dart';

class LiveList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveListController>(
      init: LiveListController(),
      builder: (_) {
        return Obx(() {
          if (_.rooms.isEmpty) {
            return const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            ); // 或者顯示一個加載中的指示器
          }
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 每行顯示兩個項目
              childAspectRatio: 1, // 正方形項目
              crossAxisSpacing: 10, // 水平間隔
              mainAxisSpacing: 10, // 垂直間隔
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RoomItem(room: _.rooms[index]);
              },
              childCount: _.rooms.length,
            ),
          );
        });
      },
    );
  }
}
