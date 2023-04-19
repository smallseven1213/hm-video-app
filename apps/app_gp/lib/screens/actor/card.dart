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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Stack(
        children: [
          if (actor.coverVertical != '' && actor.coverVertical != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SidImage(
                  key: ValueKey(actor.coverVertical),
                  sid: actor.coverVertical ?? actor.photoSid,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (actor.coverVertical == '' || actor.coverVertical == null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5], // 控制顏色分佈的位置
                    colors: [
                      Color(0xFF00091A), // 左上角顏色
                      Color(0xFFFF4545), // 位於中間位置的顏色
                    ],
                  ),
                ),
                // 您可以在這裡添加其他屬性，例如寬度、高度或子組件
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
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
                      const Text(
                        '女優簡介',
                        style: TextStyle(
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
                      InkWell(
                        onTap: () {
                          userFavoritesActorController.addActor(actor);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Text(
                                actor.actorCollectTimes.toString(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.favorite_outline,
                                size: 12,
                                color: Color(0xFF21AFFF),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                userFavoritesActorController.addActor(actor);
              },
              child: Container(
                width: 30,
                height: 30,
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      actor.actorCollectTimes.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.favorite_outline,
                      size: 12,
                      color: Color(0xFF21AFFF),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
