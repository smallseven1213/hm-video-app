import 'dart:ui';
import 'package:app_ra/config/colors.dart';
import 'package:app_ra/screens/video/video_player_area/enums.dart';
import 'package:app_ra/utils/purchase.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/apis/vod_api.dart';
import '../../../widgets/button.dart';

enum PurchasePromotionType {
  enough,
  notEnough,
  becomeVip,
}

class Vip extends StatelessWidget {
  final int timeLength;
  const Vip({
    super.key,
    required this.timeLength,
  });

  @override
  Widget build(BuildContext context) {
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
              '試看結束，升級觀看完整版',
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
            // todo : 內容：解鎖後可完整播放
            Text(
              '解鎖後可完整播放',
              style: TextStyle(
                color: AppColors.colors[ColorKeys.primary],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        // 開通VIP按鈕
        SizedBox(
          width: 87,
          height: 35,
          child: Button(
            text: '開通VIP',
            size: 'small',
            onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
          ),
        ),
      ],
    );
  }
}

final vodApi = VodApi();

class Coin extends StatelessWidget {
  final String buyPoints;
  final String userPoints;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  const Coin({
    super.key,
    required this.buyPoints,
    required this.userPoints,
    required this.videoId,
    required this.videoPlayerInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '試看結束，此視頻需付費購買',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '價格：$buyPoints金幣',
          // '價格：${videoBase.buyPoints}金幣',
          style: const TextStyle(color: Color(0xffffd900), fontSize: 13),
        ),
        const SizedBox(height: 5),
        Text(
          '您目前擁有的金幣：$userPoints金幣',
          style: const TextStyle(color: Color(0xff939393), fontSize: 13),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 183,
          child: Button(
            text: int.parse(userPoints) < int.parse(buyPoints)
                ? '金幣不足，立即購買'
                : '立即付費觀看',
            onPressed: () => purchase(
              context,
              id: videoId,
              onSuccess: () => videoPlayerInfo.videoPlayerController?.play(),
            ),
          ),
        )
      ],
    );
  }
}

class PurchasePromotion extends StatelessWidget {
  final String coverHorizontal;
  final String buyPoints;
  final int timeLength;
  final int chargeType;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;

  const PurchasePromotion({
    Key? key,
    required this.coverHorizontal,
    required this.buyPoints,
    required this.timeLength,
    required this.chargeType,
    required this.videoId,
    required this.videoPlayerInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SidImage(
          key: ValueKey(coverHorizontal),
          sid: coverHorizontal,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // sigma值控制模糊程度
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        Center(
          child: chargeType == ChargeType.vip.index
              ? Vip(timeLength: timeLength)
              : UserInfoConsumer(
                  child: (User info, isVIP, isGuest) {
                    if (info.id.isEmpty) {
                      return const SizedBox();
                    }
                    return Coin(
                      userPoints: info.points ?? '0',
                      buyPoints: buyPoints,
                      videoId: videoId,
                      videoPlayerInfo: videoPlayerInfo,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
