import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';


class PurchasePromotion extends StatelessWidget {
  final String buyPoints;
  final String tag;
  final int timeLength;
  final int chargeType;
  final int videoId;
  final VideoPlayerInfo videoPlayerInfo;
  final Widget Function(int timeLength) vipPartBuilder;
  final Widget Function({
    required String buyPoints,
    required int videoId,
    required VideoPlayerInfo videoPlayerInfo,
    required int timeLength,
    required Function() onSuccess,
  }) coinPartBuilder;

  const PurchasePromotion({
    Key? key,
    required this.tag,
    required this.buyPoints,
    required this.timeLength,
    required this.chargeType,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.vipPartBuilder,
    required this.coinPartBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: chargeType == ChargeType.vip.index
          ? vipPartBuilder(timeLength)
          : coinPartBuilder(
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
            ),
    );
  }
}
