import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/enums/charge_type.dart';

import '../purchase_promotion/coin_part.dart';
import '../purchase_promotion/vip_part.dart';

class PurchasePromotion extends StatelessWidget {
  final String buyPoints;
  final String tag;
  final int timeLength;
  final int chargeType;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;

  const PurchasePromotion({
    Key? key,
    required this.tag,
    required this.buyPoints,
    required this.timeLength,
    required this.chargeType,
    required this.videoId,
    required this.videoPlayerInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: chargeType == ChargeType.vip.index
            ? VipPart(timeLength: timeLength)
            : CoinPart(
                direction: Direction.vertical,
                buyPoints: buyPoints,
                videoId: videoId,
                videoPlayerInfo: videoPlayerInfo,
                timeLength: timeLength,
                onSuccess: () {
                  final ShortVideoDetailController shortVideoDetailController =
                      Get.find<ShortVideoDetailController>(tag: tag);
                  shortVideoDetailController.mutateAll();
                  videoPlayerInfo.videoPlayerController?.play();
                },
              ));
  }
}
