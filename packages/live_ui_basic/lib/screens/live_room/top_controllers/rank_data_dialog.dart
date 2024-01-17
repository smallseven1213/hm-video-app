import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_core/models/room_rank.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_ui_basic/widgets/rank_number.dart';

class RankDataDialog extends StatefulWidget {
  final RoomRank? roomRank;
  // onClose
  final Function()? onClose;

  const RankDataDialog({Key? key, this.roomRank, this.onClose})
      : super(key: key);

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
        return Container(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RankNumber(number: index + 1),
              const SizedBox(width: 3),
              Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: rankItems[index].avatar.isNotEmpty &&
                          rankItems[index].avatar != ""
                      ? Image.network(
                          rankItems[index].avatar,
                          fit: BoxFit.cover,
                          width: 18,
                          height: 18,
                        )
                      : SvgPicture.asset(
                          'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                          width: 18,
                          height: 18,
                          fit: BoxFit.cover,
                        )),
              const SizedBox(width: 3),
              Expanded(
                flex: 1,
                child: Text(rankItems[index].nickname,
                    style: TextStyle(fontSize: 11, color: Colors.white)),
              ),
              const SizedBox(width: 3),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(rankItems[index].amount.toString(),
                      style: TextStyle(fontSize: 11, color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomRank = widget.roomRank;

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            SizedBox(
              height: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      'packages/live_ui_basic/assets/images/rank_diamondlist.webp',
                      width: 12,
                      height: 12),
                  const SizedBox(width: 10),
                  const Text(
                    "鑽石排行榜",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: widget.onClose,
                      child: Image.asset(
                          'packages/live_ui_basic/assets/images/room_close.webp',
                          width: 12,
                          height: 12),
                    ),
                  ))
                ],
              ),
            ),
            // height 10
            const SizedBox(height: 10),
            SizedBox(
              height: 20, // 设置 TabBar 的高度为 15px
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: TextStyle(fontSize: 9), // 设置 Tab 文字大小
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 1.0, color: Colors.grey),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                isScrollable: true,
                tabs: [
                  Tab(text: '本場直播'),
                  Tab(text: '今日'),
                  Tab(text: '7日'),
                  Tab(text: '30日'),
                ],
              ),
            ),
            // height 10
            const SizedBox(height: 10),
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
