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
import 'package:shared/widgets/short_video_player/short_video_mute_button.dart';

import '../../apis/vod_api.dart';
import '../../localization/shared_localization_delegate.dart';
import '../../models/hm_api_response.dart';
import '../../models/videos_tag.dart';

// 常量和枚舉類型
enum PurchaseResult {
  success,
  insufficientGold,
  failed,
}

class ShortCardInfo extends StatelessWidget {
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool displayActorAvatar;
  final Function showConfirmDialog;
  final bool? showMuteButton;

  ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    required this.showConfirmDialog,
    this.displayActorAvatar = true,
    this.showMuteButton = true,
  }) : super(key: key);

  final vodApi = VodApi();

  // 提取的方法，用於處理購買操作的結果
  void handlePurchaseResult(
    BuildContext context,
    HMApiResponse results, {
    required Function onSuccess,
    required SharedLocalizations localizations,
  }) {
    bool coinNotEnough = results.code == '50508';
    switch (results.code) {
      case '00':
        onSuccess();
        break;
      default:
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
        break;
    }
  }

  // 購買方法
  void purchase(
    BuildContext context, {
    required int id,
    required Function onSuccess,
  }) async {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    try {
      HMApiResponse results = await vodApi.purchase(id);
      handlePurchaseResult(context, results,
          onSuccess: onSuccess, localizations: localizations);
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

  Widget _buildTags(
    BuildContext context,
    VideoPlayerInfo videoPlayerInfo,
    List<VideoTag> tags,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 4,
        runSpacing: 4,
        children: tags
            .map(
              (tag) => GestureDetector(
                onTap: () async {
                  videoPlayerInfo
                      .observableVideoPlayerController.videoPlayerController
                      ?.pause();
                  await MyRouteDelegate.of(context).push(
                    AppRoutes.supplierTag,
                    args: {'tagId': tag.id, 'tagName': tag.name},
                  );
                  videoPlayerInfo
                      .observableVideoPlayerController.videoPlayerController
                      ?.play();
                },
                child: ShortCardInfoTag(name: '#${tag.name}'),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSupplierInfo(
    BuildContext context,
    VideoPlayerInfo videoPlayerInfo,
  ) {
    return GestureDetector(
      onTap: () async {
        videoPlayerInfo.observableVideoPlayerController.videoPlayerController
            ?.pause();
        await MyRouteDelegate.of(context).push(
          AppRoutes.supplier,
          args: {'id': data.supplier!.id},
        );
        videoPlayerInfo.observableVideoPlayerController.videoPlayerController
            ?.play();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (displayActorAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: AvatarWidget(
                photoSid: data.supplier!.photoSid,
                width: 40,
                height: 40,
              ),
            ),
          Text(
            '${displayActorAvatar ? '' : '@'}${data.supplier!.aliasName}',
            style: TextStyle(
              fontSize: displayActorAvatar ? 13 : 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // 創建一個組件來顯示購買按鈕
  Widget _buildPurchaseButton({
    context,
    onTap,
    video,
    borderColor,
    textColor,
    text,
    icon,
  }) {
    return InkWell(
      onTap: onTap,
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
                color: borderColor,
                width: 1,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(top: -1, left: -1, child: icon),
        ],
      ),
    );
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 供應師
                      if (data.supplier != null)
                        _buildSupplierInfo(context, videoPlayerInfo),
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
                      // 標籤
                      if (data.tag.isNotEmpty)
                        _buildTags(context, videoPlayerInfo, data.tag),
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
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: video.chargeType ==
                                            ChargeType.vip.index
                                        ? _buildPurchaseButton(
                                            context: context,
                                            onTap: () =>
                                                MyRouteDelegate.of(context)
                                                    .push(AppRoutes.vip),
                                            borderColor: const Color(0xffcecece)
                                                .withOpacity(0.7),
                                            textColor: Colors.white,
                                            text:
                                                '${localizations.translate('upgrade_to_full_version')} ${getTimeString(video.timeLength)}',
                                            icon: const Image(
                                              image: AssetImage(
                                                  'assets/images/purchase/icon-short-vip.webp'),
                                              width: 25,
                                            ))
                                        : _buildPurchaseButton(
                                            context: context,
                                            onTap: () => purchase(
                                              context,
                                              id: video.id,
                                              onSuccess: () {
                                                final ShortVideoDetailController
                                                    shortVideoDetailController =
                                                    Get.find<
                                                            ShortVideoDetailController>(
                                                        tag: tag);
                                                shortVideoDetailController
                                                    .mutateAll();
                                              },
                                            ),
                                            borderColor:
                                                const Color(0xffe7b400),
                                            textColor: Colors.white,
                                            text:
                                                '${video.buyPoint} ${localizations.translate('count_gold_coins_to_unlock')} ${getTimeString(video.timeLength)}',
                                            icon: const Image(
                                              image: AssetImage(
                                                  'assets/images/purchase/icon-short-coin.webp'),
                                              width: 30,
                                            ),
                                          ),
                                  )
                                : const SizedBox(),
                      ),
                    ],
                  ),
                ),
                if (showMuteButton == true)
                  ShortVideoMuteButton(
                    controller: videoPlayerInfo.observableVideoPlayerController,
                  ),
              ],
            ));
      },
    );
  }
}
