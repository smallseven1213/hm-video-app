import 'package:flutter/material.dart';
import 'package:shared/utils/purchase.dart';
import 'package:app_wl_tw1/utils/show_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/utils/controller_tag_genarator.dart';

import '../../localization/i18n.dart';

class PurchaseBlock extends StatefulWidget {
  final Vod videoDetail;
  final int id;
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
                          Expanded(
                            child: Row(
                              children: [
                                const Image(
                                  image: AssetImage(
                                      'assets/images/purchase/icon-vip.webp'),
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    I18n.activateVipForFree,
                                    style: const TextStyle(
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
                              child: Text(
                                I18n.viewDetails,
                                style: const TextStyle(
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
                                        '${I18n.notEnough} ${widget.videoDetail.buyPoint}${I18n.coinsUnlock}',
                                        style: const TextStyle(
                                          color: Color(0xff644c14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => purchase(
                                  context,
                                  type: PurchaseType.video,
                                  id: widget.id,
                                  onSuccess: () {
                                    final controllerTag =
                                        genaratorLongVideoDetailTag(
                                            widget.id.toString());
                                    final videoDetailController =
                                        Get.find<VideoDetailController>(
                                            tag: controllerTag);
                                    videoDetailController.mutateAll();
                                    videoPlayerInfo.videoPlayerController
                                        ?.play();
                                  },
                                  showConfirmDialog: showConfirmDialog,
                                ),
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
                                  child: Text(
                                    I18n.unlockNow,
                                    style: const TextStyle(
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
