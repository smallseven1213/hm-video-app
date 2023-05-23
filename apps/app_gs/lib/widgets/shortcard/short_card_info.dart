import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/navigator/delegate.dart';

import 'short_card_info_tag.dart';

final logger = Logger();

class ShortCardInfo extends StatelessWidget {
  final int index;
  final ShortVideoDetail data;
  final String title;
  final String videoUrl;

  const ShortCardInfo({
    Key? key,
    required this.index,
    required this.data,
    required this.title,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isObsVideoPlayerControllerReady =
        Get.isRegistered<ObservableVideoPlayerController>(tag: videoUrl);
    if (isObsVideoPlayerControllerReady) {
      logger.i('RENDER OBX: ShortCardInfo');
      final obsVideoPlayerController =
          Get.find<ObservableVideoPlayerController>(tag: videoUrl);
      return Positioned(
        bottom: 10,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          // color: Colors.tealAccent.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // 演員
              // if (data.actors!.isNotEmpty)
              //   Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       ActorAvatar(
              //           photoSid: data.actors![0].photoSid,
              //           width: 30,
              //           height: 30),
              //       const SizedBox(width: 6),
              //       Text(data.actors![0].name,
              //           style: const TextStyle(
              //             fontSize: 15,
              //             color: Colors.white,
              //           )),
              //     ],
              //   ),
              // 供應商
              if (data.supplier != null) ...[
                InkWell(
                  onTap: () async {
                    obsVideoPlayerController.pause();
                    logger.i('RENDER OBX toGo!!');
                    await MyRouteDelegate.of(context).push(
                        AppRoutes.supplier.value,
                        useBottomToTopAnimation: true,
                        args: {
                          'id': data.supplier!.id,
                        });
                    logger.i('RENDER OBX isBack!!');
                    obsVideoPlayerController.play();
                  },
                  child: Row(children: [
                    ActorAvatar(
                      photoSid: data.supplier!.photoSid,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(height: 8),
                    Text(data.supplier!.aliasName ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 8),
                  ]),
                )
              ],

              // 標題
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
                Row(
                  children: data.tag
                      .map((e) => InkWell(
                          onTap: () async {
                            obsVideoPlayerController.pause();
                            await MyRouteDelegate.of(context).push(
                                AppRoutes.supplierTag.value,
                                args: {'tagId': e.id, 'tagName': e.name});
                            obsVideoPlayerController.play();
                          },
                          child: ShortCardInfoTag(name: '#${e.name}')))
                      .toList(),
                ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
