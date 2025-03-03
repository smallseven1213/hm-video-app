import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_core/models/room_rank.dart';

class RankList extends StatelessWidget {
  final RoomRank? roomRank;

  const RankList({Key? key, this.roomRank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (roomRank == null) {
      return Container();
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: roomRank!.current.length,
      itemBuilder: (context, index) {
        RankItem item = roomRank!.current[index];
        return Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            clipBehavior: Clip.antiAlias,
            child: item.avatar.isNotEmpty && item.avatar != ""
                ? Image.network(item.avatar,
                    fit: BoxFit.cover, width: 20, height: 20)
                : SvgPicture.asset(
                    'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ));
      },
    );
  }
}
