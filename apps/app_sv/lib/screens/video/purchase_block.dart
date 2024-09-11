import 'package:flutter/material.dart';
import 'package:app_sv/utils/purchase.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_detail_controller.dart';

import 'package:shared/navigator/delegate.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/enums/charge_type.dart';

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
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        image: const DecorationImage(
                          image:
                              AssetImage('assets/images/purchase/img-vip.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 41,
                        right: 36,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/purchase/icon-vip.webp'),
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    '開通 VIP 無限看片',
                                    style: TextStyle(
                                      color: Colors.white,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Text(
                                '查看詳情',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/purchase/img-coin.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 41,
                            right: 36,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Image(
                                      image: AssetImage(
                                          'assets/images/purchase/icon-coin.webp'),
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xff8b6712),
                                    borderRadius: BorderRadius.circular(32.0),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: const Text(
                                    '立即解鎖',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
