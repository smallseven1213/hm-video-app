import 'package:flutter/material.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/hm_api_response.dart';
import 'package:shared/models/user.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../localization/i18n.dart';
import '../../utils/show_confirm_dialog.dart';
import '../button.dart';

enum Direction {
  horizontal,
  vertical,
}

final vodApi = VodApi();

void purchase(
  BuildContext context, {
  required int id,
  required Function onSuccess,
}) async {
  try {
    HMApiResponse results = await vodApi.purchase(id);
    bool coinNotEnough = results.code == '50508';
    if (results.code == '00') {
      onSuccess();
    } else {
      if (context.mounted) {
        showConfirmDialog(
          context: context,
          title: coinNotEnough
              ? I18n.insufficientGoldBalance
              : I18n.purchaseFailed,
          message:
              coinNotEnough ? I18n.goToTopUpNowForFullExp : results.message,
          showCancelButton: coinNotEnough,
          confirmButtonText: coinNotEnough ? I18n.goToTopUp : I18n.confirm,
          cancelButtonText: I18n.cancel,
          onConfirm: () => coinNotEnough
              ? MyRouteDelegate.of(context).push(AppRoutes.coin)
              : null,
        );
      }
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    showConfirmDialog(
      context: context,
      title: I18n.purchaseFailed,
      message: I18n.purchaseFailed,
      showCancelButton: false,
      onConfirm: () {
        // Navigator.of(context).pop();
      },
    );
  }
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
          width: 100,
          height: 35,
          child: Button(
            size: 'small',
            text: I18n.payToWatch,
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
