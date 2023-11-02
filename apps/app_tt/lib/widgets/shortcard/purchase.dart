import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../screens/video/video_player_area/enums.dart';
import '../../utils/purchase.dart';

class PurchaseWidget extends StatelessWidget {
  final int vodId;
  final String tag;

  PurchaseWidget({required this.vodId, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ShortVideoConsumer(
      vodId: vodId,
      tag: tag,
      child: ({
        required isLoading,
        required video,
        required videoDetail,
        required videoUrl,
      }) =>
          Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        child: video!.isAvailable == false
            ? video.chargeType == ChargeType.vip.index
                ? InkWell(
                    onTap: () =>
                        MyRouteDelegate.of(context).push(AppRoutes.vip),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 30,
                            top: 5,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xffcecece).withOpacity(0.7),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${I18n.upgradeToVipForUnlimitedMovie} ${getTimeString(video.timeLength)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: -1,
                          left: -1,
                          child: Image(
                            image: AssetImage(
                                'assets/images/purchase/icon-short-vip.webp'),
                            width: 25,
                          ),
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () => purchase(
                      context,
                      id: video.id,
                      onSuccess: () {
                        final ShortVideoDetailController
                            shortVideoDetailController =
                            Get.find<ShortVideoDetailController>(tag: tag);
                        shortVideoDetailController.mutateAll();
                      },
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 35,
                            top: 5,
                            bottom: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xffe7b400),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${video.buyPoint} ${I18n.countGoldCoinsToUnlock} ${getTimeString(video.timeLength)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: -1,
                          left: -1,
                          child: Image(
                            image: AssetImage(
                                'assets/images/purchase/icon-short-coin.webp'),
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  )
            : const SizedBox(),
      ),
    );
  }
}
