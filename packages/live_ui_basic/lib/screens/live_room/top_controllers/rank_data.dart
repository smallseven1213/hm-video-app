import 'package:flutter/material.dart';
import 'package:live_core/models/room_rank.dart';

import 'rank_data_dialog.dart';

class RankData extends StatefulWidget {
  final RoomRank? roomRank;

  RankData({Key? key, this.roomRank}) : super(key: key);
  @override
  _RankDataState createState() => _RankDataState();
}

class _RankDataState extends State<RankData> {
  GlobalKey containerKey = GlobalKey();

  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    final RenderBox renderBox =
        containerKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          overlayEntry!.remove();
          overlayEntry = null;
        },
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: offset.dy + size.height + 10,
              width: 250,
              child: GestureDetector(
                onTap: () {}, // 防止點擊事件冒泡到外層的 GestureDetector
                child: Container(
                  height: 160,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xcc242a3d),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RankDataDialog(roomRank: widget.roomRank),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (overlayEntry != null) {
          overlayEntry!.remove();
          overlayEntry = null;
        } else {
          showOverlay(context);
        }
      },
      child: Container(
        key: containerKey,
        height: 20,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xbdf771b5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'packages/live_ui_basic/assets/images/rank_diamond.webp',
                width: 12,
                height: 12),
            const SizedBox(width: 3),
            Text("${widget.roomRank?.trank ?? "0"} 排行榜",
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            const SizedBox(width: 3),
            Image.asset(
                'packages/live_ui_basic/assets/images/rank_arrow_right.webp',
                width: 12,
                height: 12),
          ],
        ),
      ),
    );
  }
}
