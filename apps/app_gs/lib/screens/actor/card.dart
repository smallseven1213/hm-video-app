import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/widgets/sid_image.dart';

class ActorCard extends SliverPersistentHeaderDelegate {
  final Actor actor;

  ActorCard({
    required this.actor,
  });

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent =>
      200; // You can adjust this value for the initial height of the ActorCard

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final UserFavoritesActorController userFavoritesActorController =
        Get.find<UserFavoritesActorController>();

    // Calculate opacity based on the shrinkOffset
    // final double opacity = 1 - shrinkOffset / (maxExtent - minExtent);
    // final double opacity = 1 - shrinkOffset / (maxExtent - minExtent);
    final double opacity = 1 - shrinkOffset / maxExtent;
    final double percentage = shrinkOffset / maxExtent;

    // Scale image and name based on the percentage

    final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;
    final double fontSize = lerpDouble(14, 15, percentage)!;
    // logger.i('percentage => $percentage');

    // Calculate horizontal and vertical centering
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
    final leftPadding = (screenWidth - imageSize - textWidth - 8) /
        2; // Subtract 8 for the space between image and text

    return Container(
      color: Color(0xFF001a40).withOpacity(1 - opacity),
      child: Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: Container(
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
          ),
          Positioned(
            top: lerpDouble(100, (kToolbarHeight - imageSize) / 2, percentage),
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
            top: lerpDouble(110, (kToolbarHeight - fontSize) / 2, percentage),
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
              top: 0,
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
          if (Navigator.canPop(context))
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                width: kToolbarHeight, // width of the AppBar's leading area
                height: kToolbarHeight, // height of the AppBar's leading area
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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

    // return Container(
    //   child: Stack(
    //     children: [
    //       if (actor.coverVertical!.isNotEmpty)
    //         Positioned.fill(
    //           child: SidImage(
    //             sid: actor.coverVertical!,
    //             fit: BoxFit.cover,
    //             width: double.infinity,
    //           ),
    //         ),
    //       Positioned.fill(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               colors: [
    //                 const Color(0xFF4277DC)
    //                     .withOpacity(0.5), // Adjust the opacity here
    //                 const Color(0xFF4378DC).withOpacity(1.0),
    //               ],
    //               begin: Alignment.topCenter,
    //               end: Alignment.bottomCenter,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // SizedBox(
    //             //   width: 80,
    //             //   height: 80,
    //             //   child: ClipRRect(
    //             //     borderRadius: BorderRadius.circular(80),
    //             //     child: SidImage(
    //             //         key: ValueKey(actor.photoSid),
    //             //         sid: actor.photoSid,
    //             //         width: 80,
    //             //         height: 80,
    //             //         fit: BoxFit.cover),
    //             //   ),
    //             // ),
    //             const SizedBox(width: 8),
    //             Flexible(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   // Text(
    //                   //   actor.name,
    //                   //   style: const TextStyle(
    //                   //       fontWeight: FontWeight.bold,
    //                   //       fontSize: 12,
    //                   //       color: Colors.white),
    //                   // ),
    //                   const SizedBox(height: 10),
    //                   Text(
    //                     actor.description!,
    //                     style:
    //                         const TextStyle(fontSize: 12, color: Colors.white),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Positioned(
    //         top: imageTopPadding,
    //         left: 10,
    //         child: SizedBox(
    //           width: imageSize,
    //           height: imageSize,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(80),
    //             child: SidImage(
    //                 key: ValueKey(actor.photoSid),
    //                 sid: actor.photoSid,
    //                 width: imageSize,
    //                 height: imageSize,
    //                 fit: BoxFit.cover),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         top: textTopPadding,
    //         left: imageSize + 18,
    //         child: Text(
    //           actor.name,
    //           style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: fontSize,
    //               color: Colors.white),
    //         ),
    //       ),
    //       Positioned(
    //         top: 20,
    //         right: 20,
            // child: Obx(() {
            //   var isLiked = userFavoritesActorController.actors
            //       .any((e) => e.id == actor.id);
            //   return Opacity(
            //     opacity: opacity,
            //     child: InkWell(
            //       onTap: () {
            //         if (isLiked) {
            //           userFavoritesActorController.removeActor([actor.id]);
            //           return;
            //         } else {
            //           userFavoritesActorController.addActor(actor);
            //         }
            //       },
            //       child: Row(
            //         children: [
            //           Icon(
            //             isLiked ? Icons.favorite_sharp : Icons.favorite_outline,
            //             size: 20,
            //             color: const Color(0xFF21AFFF),
            //           ),
            //           const SizedBox(width: 6),
            //           Text(
            //             actor.actorCollectTimes.toString(),
            //             style: const TextStyle(
            //               fontSize: 12,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   );
            // }),
    //       )
    //     ],
    //   ),
    // );

/**
 * Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
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
                        actorVodController.totalCount.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
 */