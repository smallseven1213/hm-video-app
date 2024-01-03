import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_core/models/room_rank.dart';
import 'package:live_core/widgets/live_image.dart';

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
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            clipBehavior: Clip.antiAlias,
            child: item.avatar.isNotEmpty && item.avatar != ""
                ? LiveImage(
                    base64Url: item.avatar,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  )
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
