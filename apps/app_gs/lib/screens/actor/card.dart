import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_controller.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/actor_avatar.dart';

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

    return Container(
      color: const Color(0xFF001a40).withOpacity(1 - opacity),
      child: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/supplier_card_bg.webp'),
              fit: BoxFit.fill,
            ),
          ),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(67, 120, 220, 0.65),
                    Color(0xFF001C46),
                  ],
                  stops: [
                    -0.06,
                    1.0,
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
            child: ActorAvatar(
              photoSid: actor.photoSid,
              width: imageSize,
              height: imageSize,
            ),
          ),
          Positioned(
            top: lerpDouble(
                105,
                ((kToolbarHeight - fontSize) / 2) + systemTopBarHeight,
                percentage),
            left: lerpDouble(100, leftPadding + imageSize + 8, percentage)!,
            child: (actor.name.isEmpty)
                ? kIsWeb
                    ? Shimmer.fromColors(
                        baseColor: const Color(0xFF003068),
                        highlightColor: const Color(0xFF00234d),
                        child: Container(
                          width: 100,
                          height: fontSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
                : Text(
                    actor.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                        color: Colors.white),
                  ),
          ),
          Positioned(
            top: lerpDouble(
                130, (kToolbarHeight - 12) / 2 + fontSize, percentage),
            left: 100,
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: screenWidth - 108,
                child: (actor.description == null || actor.description!.isEmpty)
                    ? kIsWeb
                        ? Shimmer.fromColors(
                            baseColor: const Color(0xFF003068),
                            highlightColor: const Color(0xFF00234d),
                            child: Container(
                              width: screenWidth - 108,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                    : Text(
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
          ),
          Positioned(
            top: lerpDouble(
                105, (kToolbarHeight - 12) / 2 + fontSize, percentage),
            right: 8,
            child: Opacity(
                opacity: opacity,
                child: UserLike(
                  actor: actor,
                )),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ActorCard oldDelegate) {
    return oldDelegate.actor != actor || oldDelegate.context != context;
  }
}

class UserLike extends StatelessWidget {
  const UserLike({
    Key? key,
    required this.actor,
  }) : super(key: key);

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    if (actor.id == 0) {
      return const SizedBox();
    }
    final UserFavoritesActorController userFavoritesActorController =
        Get.find<UserFavoritesActorController>();
    ActorController actorController = Get.find(tag: 'actor-${actor.id}');
    return Obx(() {
      var isLiked =
          userFavoritesActorController.actors.any((e) => e.id == actor.id);
      IconData iconData =
          isLiked ? Icons.favorite_sharp : Icons.favorite_outline;
      return GestureDetector(
        onTap: () {
          if (isLiked) {
            userFavoritesActorController.removeActor([actor.id]);
            actorController.decrementActorCollectTimes();
            return;
          } else {
            userFavoritesActorController.addActor(actor);
            actorController.incrementActorCollectTimes();
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
              actorController.actor.value.actorCollectTimes.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }
}
