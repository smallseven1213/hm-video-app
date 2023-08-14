import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/navigator/delegate.dart';

import '../../screens/short/short_card_info_tag.dart';

final logger = Logger();

class ShortCardInfo extends StatefulWidget {
  final String obsKey;
  final ShortVideoDetail data;
  final String title;

  const ShortCardInfo({
    Key? key,
    required this.obsKey,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  _ShortCardInfoState createState() => _ShortCardInfoState();
}

class _ShortCardInfoState extends State<ShortCardInfo> {
  late ObservableVideoPlayerController obsVideoPlayerController;

  @override
  void initState() {
    super.initState();
    obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.obsKey);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.data.supplier != null) ...[
              GestureDetector(
                onTap: () async {
                  obsVideoPlayerController.pause();
                  await MyRouteDelegate.of(context)
                      .push(AppRoutes.supplier, args: {
                    'id': widget.data.supplier!.id,
                  });
                  obsVideoPlayerController.play();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActorAvatar(
                      photoSid: widget.data.supplier!.photoSid,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(height: 8),
                    Text(widget.data.supplier!.aliasName ?? '',
                        style: const TextStyle(
                          fontSize: 13,
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
                widget.title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            if (widget.data.tag.isNotEmpty)
              Wrap(
                direction: Axis.horizontal,
                spacing: 4,
                runSpacing: 4,
                children: widget.data.tag
                    .map((e) => GestureDetector(
                        onTap: () async {
                          obsVideoPlayerController.pause();
                          await MyRouteDelegate.of(context).push(
                              AppRoutes.supplierTag,
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
  }
}
