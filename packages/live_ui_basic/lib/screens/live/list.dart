import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_ui_basic/screens/live/room_item.dart';
import 'package:live_ui_basic/widgets/no_result.dart';

class LiveList extends StatefulWidget {
  const LiveList({Key? key}) : super(key: key);

  @override
  _LiveListState createState() => _LiveListState();
}

class _LiveListState extends State<LiveList> {
  final LiveListController _controller = Get.find<LiveListController>();

  @override
  void initState() {
    super.initState();
    _controller.connectWs();
  }

  @override
  void dispose() {
    _controller.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.rooms.isEmpty) {
        return const SliverToBoxAdapter(child: NoResult()); // 或者顯示一個加載中的指示器
      }
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 每行顯示兩個項目
          childAspectRatio: 1, // 正方形項目
          crossAxisSpacing: 10, // 水平間隔
          mainAxisSpacing: 10, // 垂直間隔
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => RoomItem(
            key: ValueKey(_controller.rooms[index].id),
            room: _controller.rooms[index],
          ),
          childCount: _controller.rooms.length,
        ),
      );
    });
  }
}
