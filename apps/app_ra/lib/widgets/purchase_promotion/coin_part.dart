import 'package:flutter/material.dart';
import 'package:shared/models/user.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../utils/purchase.dart';
import '../button.dart';

class Coin extends StatelessWidget {
  final String buyPoints;
  final String userPoints;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  final int timeLength;
  final Function? onSuccess;
  final int? direction; // 0:水平, else:垂直
  const Coin({
    super.key,
    required this.buyPoints,
    required this.userPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    this.direction = 0,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // todo : 標題：試看結束，升級觀看完整版
              const Text(
                '試看結束，此影片需付費購買',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '片長：${getTimeString(timeLength)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '價格：$buyPoints金幣',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '您目前擁有的金幣：$userPoints金幣',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          //開通VIP按鈕
          SizedBox(
            width: 87,
            height: 35,
            child: Button(
              size: 'small',
              text: double.parse(userPoints) < double.parse(buyPoints)
                  ? '金幣不足'
                  : '付費觀看',
              onPressed: () => purchase(
                context,
                id: videoId,
                onSuccess: onSuccess,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '試看結束，此影片需付費購買',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '片長：${getTimeString(timeLength)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '價格：$buyPoints金幣',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '您目前擁有的金幣：$userPoints金幣',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 87,
          height: 35,
          child: Button(
            size: 'small',
            text: double.parse(userPoints) < double.parse(buyPoints)
                ? '金幣不足'
                : '付費觀看',
            backgroundColor: Colors.black,
            onPressed: () => purchase(
              context,
              id: videoId,
              onSuccess: onSuccess,
            ),
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
  final int? direction; // 0:水平, else:垂直

  const CoinPart({
    Key? key,
    required this.buyPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    this.onSuccess,
    this.direction = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInfoConsumer(
      child: (User info, isVIP, isGuest) {
        if (info.id.isEmpty) {
          return const SizedBox();
        }
        return Coin(
          direction: direction,
          userPoints: info.points ?? '0',
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
