import 'package:app_ab/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/user.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../utils/purchase.dart';
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
    this.direction = Direction.horizontal,
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
              const Text(
                '试看结束，此影片需付费购买',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '片长：${getTimeString(timeLength)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '价格：$buyPoints金币',
                style: TextStyle(
                  color: AppColors.colors[ColorKeys.secondary],
                  fontSize: 13,
                ),
              ),
              Text(
                '您目前拥有的金币：$userPoints金币',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 90,
            height: 35,
            child: Button(
              size: 'small',
              text: '付费观看',
              onPressed: () => purchase(
                context,
                id: videoId,
                onSuccess: onSuccess!,
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
              '试看结束，此影片需付费购买',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '片长：${getTimeString(timeLength)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '价格：$buyPoints金币',
              style: TextStyle(
                color: AppColors.colors[ColorKeys.secondary],
                fontSize: 13,
              ),
            ),
            Text(
              '您目前拥有的金币：$userPoints金币',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 100,
          height: 35,
          child: Button(
            size: 'small',
            text: '付费观看',
            onPressed: () => purchase(
              context,
              id: videoId,
              onSuccess: onSuccess!,
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
  final Direction? direction; // 0:水平, else:垂直

  const CoinPart({
    Key? key,
    required this.buyPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    this.onSuccess,
    this.direction = Direction.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInfoConsumer(
      child: (User info, isVIP, isGuest, isLoading) {
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
