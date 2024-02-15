import 'dart:ui';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_wl_tw1/screens/video/video_player_area/enums.dart';
import 'package:app_wl_tw1/widgets/purchase_promotion/vip_part.dart';

import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../../widgets/purchase_promotion/coin_part.dart';

final logger = Logger();

class PurchasePromotion extends StatelessWidget {
  final String coverHorizontal;
  final String buyPoints;
  final int timeLength;
  final int chargeType;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  final String title;
  final String tag;

  const PurchasePromotion({
    Key? key,
    required this.coverHorizontal,
    required this.buyPoints,
    required this.timeLength,
    required this.chargeType,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.title,
    required this.tag,
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
                ? VipPart(timeLength: timeLength)
                : CoinPart(
                    buyPoints: buyPoints,
                    videoId: videoId,
                    videoPlayerInfo: videoPlayerInfo,
                    timeLength: timeLength,
                    onSuccess: () {
                      final videoDetailController =
                          Get.find<VideoDetailController>(tag: tag);
                      videoDetailController.mutateAll();
                      videoPlayerInfo.videoPlayerController?.play();
                    },
                  )),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            title: Text(title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                )),
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => MyRouteDelegate.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
