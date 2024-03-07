import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/controllers/user_follows_controller.dart';
import 'package:live_core/models/streamer.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_core/models/streamer_profile.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/live_localization_delegate.dart';

class StreamerProfileCard extends StatelessWidget {
  final StreamerProfile profile;
  final bool? showFansCount;
  final bool? showFollowButton;
  final userFollowsController = Get.find<UserFollowsController>();

  StreamerProfileCard({
    Key? key,
    required this.profile,
    this.showFansCount = false,
    this.showFollowButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveListController controller = Get.find();
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        final room = controller.getRoomByStreamerId(profile.id);
        if (room == null) {
          MyRouteDelegate.of(context).push(
            AppRoutes.supplier,
            args: {
              'id': profile.supplierId,
            },
          );
        } else {
          MyRouteDelegate.of(context).push(
            "/live_room",
            args: {"pid": room.id},
          );
        }
      },
      child: Container(
        height: (MediaQuery.of(context).size.width - 24) / 2,
        width: (MediaQuery.of(context).size.width - 24) / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LiveImage(
                base64Url: profile.avatar ?? '',
                fit: BoxFit.cover,
              ),
            ),
            if (profile.isLive == true)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${profile.nickname}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    if (showFansCount == true)
                      Text(
                        '${profile.fansCount.toString()} ${localizations.translate('fans')}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    if (showFollowButton == true)
                      Obx(() {
                        var isFollowed = userFollowsController.follows
                            .any((e) => e.id == profile.id);

                        return Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowed
                                  ? const Color(0xff7b7b7b)
                                  : const Color(0xffae57ff),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              Streamer streamer = Streamer(
                                  id: profile.id, nickname: profile.nickname);
                              if (isFollowed) {
                                userFollowsController.unfollow(streamer.id);
                              } else {
                                userFollowsController.follow(streamer);
                              }
                            },
                            child: Text(
                                isFollowed
                                    ? localizations.translate('followed')
                                    : localizations.translate('follow'),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
