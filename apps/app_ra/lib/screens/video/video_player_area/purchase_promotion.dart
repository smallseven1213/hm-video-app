import 'dart:ui';
import 'package:app_ra/config/colors.dart';
import 'package:app_ra/screens/video/video_player_area/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
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
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              // todo : 標題：試看結束，升級觀看完整版
              Text(
                '試看結束，升級觀看完整版',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // todo : 內容：片長：{時間}
              Text(
                '片長：${getTimeString(timeLength)}',
                style: TextStyle(
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
        ),
        // 開通VIP按鈕
        SizedBox(
          width: 87,
          height: 35,
          child: Button(
            text: '開通VIP',
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
  const Coin({
    super.key,
    required this.buyPoints,
    required this.userPoints,
    required this.videoId,
  });

  purchase(context) async {
    try {
      // 這邊做付費
      var results = await vodApi.purchase(videoId);
      MyRouteDelegate.of(context).pop();
      // 付費成功後，mutate同一支影片
      final controllerTag = genaratorLongVideoDetailTag(videoId.toString());
      Get.find<VideoDetailController>(tag: controllerTag);
    } catch (e) {
      print('e: $e');
    }
  }

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
          child: int.parse(userPoints) < int.parse(buyPoints)
              ? Button(
                  text: '金幣不足，立即購買',
                  onPressed: () =>
                      MyRouteDelegate.of(context).push(AppRoutes.coin))
              : Button(text: '立即付費觀看', onPressed: () => purchase(context)),
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

  const PurchasePromotion({
    Key? key,
    required this.coverHorizontal,
    required this.buyPoints,
    required this.timeLength,
    required this.chargeType,
    required this.videoId,
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
                  child: (info, isVIP, isGuest) {
                    if (info.id.isEmpty) {
                      return const SizedBox();
                    }
                    return Coin(
                      userPoints: info.usedPoints ?? '0',
                      buyPoints: buyPoints,
                      videoId: videoId,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
