import 'package:flutter/material.dart';
import 'package:live_core/models/room_rank.dart';

import '../../../localization/live_localization_delegate.dart';
import 'rank_data_dialog.dart';

class RankData extends StatefulWidget {
  final RoomRank? roomRank;

  const RankData({Key? key, this.roomRank}) : super(key: key);
  @override
  RankDataState createState() => RankDataState();
}

class RankDataState extends State<RankData> {
  void showBottomSheetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 510,
          color: const Color(0xff242a3d),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RankDataDialog(
              roomRank: widget.roomRank,
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => showBottomSheetModal(context),
      child: Container(
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
            Text(
                "${widget.roomRank?.trank ?? "0"} ${localizations.translate('leaderboard')}",
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
