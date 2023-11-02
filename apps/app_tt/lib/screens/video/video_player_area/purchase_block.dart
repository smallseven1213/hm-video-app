import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_detail_controller.dart';

import 'package:shared/navigator/delegate.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import '../../../utils/purchase.dart';
import 'enums.dart';

class PurchaseBlock extends StatefulWidget {
  final Vod videoDetail;
  final String id;
  final String videoUrl;
  final String tag;

  const PurchaseBlock({
    super.key,
    required this.videoDetail,
    required this.id,
    required this.videoUrl,
    required this.tag,
  });

  @override
  State<PurchaseBlock> createState() => _PurchaseBlockState();
}

class _PurchaseBlockState extends State<PurchaseBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: !widget.videoDetail.isAvailable
          ? widget.videoDetail.chargeType == ChargeType.vip.index
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width - 20,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/purchase/img-vipbg.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 41,
                        right: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    I18n.upgradeToVipForUnlimitedMovie,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                MyRouteDelegate.of(context).push(AppRoutes.vip),
                            child: Container(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                  left: 15,
                                  right: 15,
                                ),
                                child: Row(
                                  children: [
                                    const Image(
                                      image: AssetImage(
                                          'assets/images/purchase/ic-vip.webp'),
                                      width: 20,
                                      height: 20,
                                    ),
                                    Text(
                                      I18n.upgradeNow,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : VideoPlayerConsumer(
                  tag: widget.videoUrl,
                  child: (VideoPlayerInfo videoPlayerInfo) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width - 20,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/purchase/img-coinbg.webp'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 41,
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '看不過癮，${widget.videoDetail.buyPoint}金幣解鎖',
                                        style: const TextStyle(
                                          color: Color(0xff644c14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => purchase(context,
                                    id: int.parse(widget.id.toString()),
                                    onSuccess: () {
                                  final videoDetailController =
                                      Get.find<VideoDetailController>(
                                          tag: widget.tag);
                                  videoDetailController.mutateAll();
                                  videoPlayerInfo.videoPlayerController?.play();
                                }),
                                child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.lock_outline_rounded,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        Text(
                                          '立即解鎖',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  })
          : const SizedBox(),
    );
  }
}
