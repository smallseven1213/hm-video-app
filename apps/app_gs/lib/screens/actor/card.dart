import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/widgets/sid_image.dart';

class ActorCard extends SliverPersistentHeaderDelegate {
  final Actor actor;
  final BuildContext context;

  ActorCard({
    required this.actor,
    required this.context,
  });

  @override
  double get minExtent {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return kToolbarHeight + statusBarHeight;
  }

  @override
  double get maxExtent =>
      200; // You can adjust this value for the initial height of the ActorCard

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final UserFavoritesActorController userFavoritesActorController =
        Get.find<UserFavoritesActorController>();

    final double opacity = 1 - shrinkOffset / maxExtent;
    final double percentage = shrinkOffset / maxExtent;

    final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;
    final double fontSize = lerpDouble(14, 15, percentage)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final textPainter = TextPainter(
      text: TextSpan(
        text: actor.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textWidth = textPainter.width;
    final systemTopBarHeight = MediaQuery.of(context).padding.top;
    final leftPadding = (screenWidth - imageSize - textWidth - 8) /
        2; // Subtract 8 for the space between image and text

    return Container(
      color: Color(0xFF001a40).withOpacity(1 - opacity),
      child: Stack(
        children: [
          if (opacity > 0)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF131E34).withOpacity(0.3),
                    const Color(0xFF4378DC).withOpacity(0.3),
                  ],
                ),
              ),
            ),
          Positioned(
            top: lerpDouble(
                100,
                ((kToolbarHeight - imageSize) / 2) + systemTopBarHeight,
                percentage),
            left: lerpDouble(10, leftPadding, percentage)!,
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: SidImage(
                    key: ValueKey(actor.photoSid),
                    sid: actor.photoSid,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            top: lerpDouble(
                110,
                ((kToolbarHeight - fontSize) / 2) + systemTopBarHeight,
                percentage),
            left: lerpDouble(100, leftPadding + imageSize + 8, percentage)!,
            child: Text(
              actor.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
            ),
          ),
          Positioned(
            top: lerpDouble(
                135, (kToolbarHeight - 12) / 2 + fontSize, percentage),
            left: 100,
            child: Opacity(
              opacity: opacity,
              child: Text(
                actor.description!,
                softWrap: true,
                maxLines: null,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white),
              ),
            ),
          ),
          if (opacity == 0)
            Positioned(
              top: 0 + systemTopBarHeight,
              right: 0,
              child: Obx(() {
                var isLiked = userFavoritesActorController.actors
                    .any((e) => e.id == actor.id);
                return Container(
                  width: kToolbarHeight, // width of the AppBar's leading area
                  height: kToolbarHeight,
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      if (isLiked) {
                        userFavoritesActorController.removeActor([actor.id]);
                        return;
                      } else {
                        userFavoritesActorController.addActor(actor);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          isLiked
                              ? Icons.favorite_sharp
                              : Icons.favorite_outline,
                          size: 20,
                          color: const Color(0xFF21AFFF),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          actor.actorCollectTimes.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          if (opacity > 0)
            Positioned(
              top: lerpDouble(
                  105, (kToolbarHeight - 12) / 2 + fontSize, percentage),
              right: 8,
              child: Opacity(
                opacity: opacity,
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Add this line
                      children: [
                        const Icon(
                          Icons.videocam_outlined,
                          color: Color(0xFF21AFFF),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          actor.actorCollectTimes.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Obx(() {
                      var isLiked = userFavoritesActorController.actors
                          .any((e) => e.id == actor.id);
                      return InkWell(
                        onTap: () {
                          if (isLiked) {
                            userFavoritesActorController
                                .removeActor([actor.id]);
                            return;
                          } else {
                            userFavoritesActorController.addActor(actor);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              isLiked
                                  ? Icons.favorite_sharp
                                  : Icons.favorite_outline,
                              size: 20,
                              color: const Color(0xFF21AFFF),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              actor.actorCollectTimes.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
