import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/short_video_player/purchase_promotion.dart';
import 'package:shared/widgets/short_video_player/short_card_info_tag.dart';

import '../../apis/vod_api.dart';
import '../../localization/shared_localization_delegate.dart';
import '../../models/hm_api_response.dart';

final logger = Logger();

class ShortCardInfo extends StatelessWidget {
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool displayActorAvatar;
  final Function showConfirmDialog;

  ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    required this.showConfirmDialog,
    this.displayActorAvatar = true,
  }) : super(key: key);

  final vodApi = VodApi();

  void purchase(
    BuildContext context, {
    required int id,
    required Function onSuccess,
  }) async {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    try {
      HMApiResponse results = await vodApi.purchase(id);
      bool coinNotEnough = results.code == '50508';
      if (results.code == '00') {
        onSuccess();
      } else {
        if (context.mounted) {
          showConfirmDialog(
            context: context,
            title: coinNotEnough
                ? localizations.translate('insufficient_gold_balance')
                : localizations.translate('purchase_failed'),
            message: coinNotEnough
                ? localizations.translate('go_to_top_up_now_for_full_exp')
                : results.message,
            showCancelButton: coinNotEnough,
            confirmButtonText: coinNotEnough
                ? localizations.translate('go_to_top_up')
                : localizations.translate('confirm'),
            cancelButtonText: localizations.translate('cancel'),
            onConfirm: () => coinNotEnough
                ? MyRouteDelegate.of(context).push(AppRoutes.coin)
                : null,
          );
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showConfirmDialog(
        context: context,
        title: localizations.translate('purchase_failed'),
        message: localizations.translate('purchase_failed'),
        showCancelButton: false,
        onConfirm: () {
          // Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return VideoPlayerConsumer(
        tag: tag,
        child: (VideoPlayerInfo videoPlayerInfo) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.supplier != null) ...[
                  GestureDetector(
                    onTap: () async {
                      videoPlayerInfo
                          .observableVideoPlayerController.videoPlayerController
                          ?.pause();
                      await MyRouteDelegate.of(context)
                          .push(AppRoutes.supplier, args: {
                        'id': data.supplier!.id,
                      });
                      videoPlayerInfo
                          .observableVideoPlayerController.videoPlayerController
                          ?.play();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        displayActorAvatar == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: AvatarWidget(
                                  photoSid: data.supplier!.photoSid,
                                  width: 40,
                                  height: 40,
                                ))
                            : const SizedBox(),
                        Text(
                            '${displayActorAvatar == true ? '' : '@'}${data.supplier!.aliasName}',
                            style: TextStyle(
                              fontSize: displayActorAvatar == true ? 13 : 15,
                              color: Colors.white,
                            )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (data.tag.isNotEmpty) ...[
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: data.tag
                        .map((e) => GestureDetector(
                            onTap: () async {
                              videoPlayerInfo.observableVideoPlayerController
                                  .videoPlayerController
                                  ?.pause();
                              await MyRouteDelegate.of(context).push(
                                AppRoutes.supplierTag,
                                args: {'tagId': e.id, 'tagName': e.name},
                              );
                              videoPlayerInfo.observableVideoPlayerController
                                  .videoPlayerController
                                  ?.play();
                            },
                            child: ShortCardInfoTag(name: '#${e.name}')))
                        .toList(),
                  ),
                  const SizedBox(height: 10)
                ],
                ShortVideoConsumer(
                    vodId: data.id,
                    tag: tag,
                    child: ({
                      required isLoading,
                      required video,
                      required videoDetail,
                      required videoUrl,
                    }) =>
                        !video!.isAvailable
                            ? video.chargeType == ChargeType.vip.index
                                ? InkWell(
                                    onTap: () => MyRouteDelegate.of(context)
                                        .push(AppRoutes.vip),
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color(0xffcecece)
                                                  .withOpacity(0.7),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '${localizations.translate('upgrade_to_full_version')} ${getTimeString(video.timeLength)}',
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
                                            Get.find<
                                                    ShortVideoDetailController>(
                                                tag: tag);
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color(0xffe7b400),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '${video.buyPoint} ${localizations.translate('count_gold_coins_to_unlock')} ${getTimeString(video.timeLength)}',
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
                            : const SizedBox()),
              ],
            ),
          );
        });
  }
}
