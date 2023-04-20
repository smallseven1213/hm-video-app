import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/widgets/sid_image.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;
  const ActorCard({
    Key? key,
    required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserFavoritesActorController userFavoritesActorController =
        Get.find<UserFavoritesActorController>();
    return Container(
      child: Stack(
        children: [
          if (actor.coverVertical!.isNotEmpty)
            Positioned.fill(
              child: SidImage(
                sid: actor.coverVertical!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4277DC)
                        .withOpacity(0.5), // Adjust the opacity here
                    const Color(0xFF4378DC).withOpacity(1.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: SidImage(
                        key: ValueKey(actor.photoSid),
                        sid: actor.photoSid,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        actor.description!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Obx(() {
              var isLiked = userFavoritesActorController.actors
                  .any((e) => e.id == actor.id);
              return InkWell(
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
                      isLiked ? Icons.favorite_sharp : Icons.favorite_outline,
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
            }),
          )
        ],
      ),
    );
  }
}

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