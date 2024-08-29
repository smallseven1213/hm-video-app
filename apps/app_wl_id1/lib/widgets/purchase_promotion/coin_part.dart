import 'package:flutter/material.dart';
import 'package:shared/models/user.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/utils/purchase.dart';
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/enums/purchase_type.dart';

import '../../localization/i18n.dart';
import '../../utils/show_confirm_dialog.dart';
import '../button.dart';

enum Direction {
  horizontal,
  vertical,
}

class Coin extends StatelessWidget {
  final String buyPoints;
  final String userPoints;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  final int timeLength;
  final Function? onSuccess;
  final Direction? direction; // 0:水平, else:垂直
  const Coin({
    super.key,
    required this.buyPoints,
    required this.userPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    this.direction = Direction.vertical,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Direction.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                I18n.thisMovieIsAvailableForPurchase,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${I18n.lengthOfFilm}：${getTimeString(timeLength)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${I18n.price}：$buyPoints${I18n.coins}',
                style: const TextStyle(
                  color: Color(0xffffd900),
                  fontSize: 13,
                ),
              ),
              Text(
                '${I18n.yourCurrentCoins}：$userPoints${I18n.coins}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 100,
            height: 35,
            child: Button(
              size: 'small',
              text: I18n.payToWatch,
              onPressed: () => purchase(
                context,
                type: PurchaseType.video,
                id: videoId,
                onSuccess: onSuccess!,
                showConfirmDialog: showConfirmDialog,
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          I18n.endOfTrialUpgradeToFullVersion,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '${I18n.lengthOfFilm}：${getTimeString(timeLength)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text('${I18n.price}：$buyPoints${I18n.coins}',
            style: const TextStyle(
              color: Color(0xffffd900),
              fontSize: 13,
            )),
        Text(
          '${I18n.yourCurrentCoins}：$userPoints${I18n.coins}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 150,
          height: 35,
          child: Button(
            size: 'small',
            text: I18n.payToWatch,
            onPressed: () {
              purchase(
                context,
                type: PurchaseType.video,
                id: videoId,
                onSuccess: onSuccess!,
                showConfirmDialog: showConfirmDialog,
              );
            },
          ),
        ),
      ],
    );
  }
}

class CoinPart extends StatelessWidget {
  final String buyPoints;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  final int timeLength;
  final Function? onSuccess;
  final Direction? direction; // 0:水平, else:垂直

  const CoinPart({
    Key? key,
    required this.buyPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    this.onSuccess,
    this.direction = Direction.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInfoV2Consumer(
      child: (
        info,
        isVIP,
        isGuest,
        isLoading,
        isInfoV2Init,
      ) {
        if (isInfoV2Init == false) {
          return const SizedBox();
        }
        return Coin(
          direction: direction,
          userPoints: info.points.toString(),
          buyPoints: buyPoints,
          videoId: videoId,
          videoPlayerInfo: videoPlayerInfo,
          timeLength: timeLength,
          onSuccess: onSuccess,
        );
      },
    );
  }
}
