import 'dart:ui';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../enums/charge_type.dart';

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
    required this.coverHorizontal,
    required this.buyPoints,
    required this.timeLength,
    required this.chargeType,
    required this.videoId,
    required this.videoPlayerInfo,
    required this.title,
    required this.tag,
    required this.vipPartBuilder,
    required this.coinPartBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SidImage(
            key: ValueKey(coverHorizontal),
            sid: coverHorizontal,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: chargeType == ChargeType.vip.index
              ? vipPartBuilder(timeLength)
              : coinPartBuilder(
                  buyPoints: buyPoints,
                  videoId: videoId,
                  videoPlayerInfo: videoPlayerInfo,
                  timeLength: timeLength,
                  onSuccess: () {
                    final controllerTag =
                        genaratorLongVideoDetailTag(videoId.toString());
                    final videoDetailController =
                        Get.find<VideoDetailController>(tag: controllerTag);
                    videoDetailController.mutateAll();
                    videoPlayerInfo.videoPlayerController?.play();
                  },
                ),
        ),
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
