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
    final leftPadding = (screenWidth - imageSize - textWidth - 8) / 2;

    return RepaintBoundary(
      child: Container(
        color: const Color(0xFF001a40).withOpacity(1 - opacity),
        child: Stack(
          children: [
            Opacity(
              opacity: opacity,
              child: SidImage(
                key: ValueKey(actor.coverVertical),
                sid: actor.coverVertical!,
                width: 500,
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
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
            Positioned(
              top: lerpDouble(
                  105, (kToolbarHeight - 12) / 2 + fontSize, percentage),
              right: 8,
              child: Obx(() {
                var isLiked = userFavoritesActorController.actors
                    .any((e) => e.id == actor.id);
                IconData iconData =
                    isLiked ? Icons.favorite_sharp : Icons.favorite_outline;
                return Opacity(
                  opacity: opacity,
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
                      children: [
                        Icon(
                          iconData,
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
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ActorCard oldDelegate) {
    return oldDelegate.actor != actor || oldDelegate.context != context;
  }
}
