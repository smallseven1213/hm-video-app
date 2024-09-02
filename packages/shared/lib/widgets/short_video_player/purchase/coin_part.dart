import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/models/hm_api_response.dart';
import 'package:shared/models/user.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/utils/purchase.dart';

import '../../../controllers/short_video_detail_controller.dart';
import '../../../localization/shared_localization_delegate.dart';
import 'purchase_button.dart';

enum Direction {
  horizontal,
  vertical,
}

final vodApi = VodApi();

class Coin extends StatelessWidget {
  final String buyPoints;
  final String userPoints;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  final int timeLength;
  final Function? onSuccess;
  final Direction? direction; // 0:水平, else:垂直
  final Function showConfirmDialog;
  final String tag;

  const Coin({
    super.key,
    required this.buyPoints,
    required this.userPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    required this.showConfirmDialog,
    required this.tag,
    this.direction = Direction.vertical,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    print('##direction: ${localizations.translate('pay_to_watch')}');

    if (direction == Direction.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations
                      .translate('this_movie_is_available_for_purchase'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${localizations.translate('duration')} ${getTimeString(timeLength)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${localizations.translate('price')} $buyPoints${localizations.translate('coins')}',
                  style: const TextStyle(
                    color: Color(0xffffd900),
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${localizations.translate('your_current_coins')} $userPoints${localizations.translate('coins')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          PurchaseButton(
            onPressed: () => purchase(
              context,
              type: PurchaseType.shortVideo,
              id: videoId,
              onSuccess: () {
                final ShortVideoDetailController shortVideoDetailController =
                    Get.find<ShortVideoDetailController>(tag: tag);
                shortVideoDetailController.mutateAll();
              },
              showConfirmDialog: showConfirmDialog,
            ),
            text: localizations.translate('pay_to_watch'),
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
          localizations.translate('end_of_trial_upgrade_to_full_version'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '${localizations.translate('duration')} ${getTimeString(timeLength)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
            '${localizations.translate('price')} $buyPoints${localizations.translate('coins')}',
            style: const TextStyle(
              color: Color(0xffffd900),
              fontSize: 13,
            )),
        Text(
          '${localizations.translate('your_current_coins')} $userPoints${localizations.translate('coins')}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: PurchaseButton(
            text: localizations.translate('pay_to_watch'),
            onPressed: () => purchase(
              context,
              type: PurchaseType.shortVideo,
              id: videoId,
              onSuccess: () {
                final ShortVideoDetailController shortVideoDetailController =
                    Get.find<ShortVideoDetailController>(tag: tag);
                shortVideoDetailController.mutateAll();
              },
              showConfirmDialog: showConfirmDialog,
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
  final Function showConfirmDialog;
  final String tag;

  const CoinPart({
    Key? key,
    required this.buyPoints,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.timeLength,
    required this.showConfirmDialog,
    required this.tag,
    this.onSuccess,
    this.direction = Direction.vertical,
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
          showConfirmDialog: showConfirmDialog,
          tag: tag,
        );
      },
    );
  }
}
