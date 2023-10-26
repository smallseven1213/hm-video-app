import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actors_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/modules/user/user_favorites_actor_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/actor_avatar.dart';

class ProfileCards extends StatefulWidget {
  final int? regionId;
  const ProfileCards({
    super.key,
    this.regionId,
  });

  @override
  _ProfileCardsState createState() => _ProfileCardsState();
}

class _ProfileCardsState extends State<ProfileCards> {
  bool isDeleting = false;
  late ActorsController actorsController;

  @override
  void initState() {
    super.initState();
    actorsController = Get.put(ActorsController(
      initialIsRecommend: true,
      initialRegion: widget.regionId,
      initialLimit: 20,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Actor> actors = actorsController.actors;
      return SizedBox(
        width: double.infinity,
        height: actors.isEmpty ? 30 : 200,
        child: actors.isEmpty
            ? const Text('暫時沒有更多了', textAlign: TextAlign.center)
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: actors.length,
                itemBuilder: (context, index) {
                  return profileCard(
                    actors[index].photoSid,
                    actors[index].name,
                    actors[index].id,
                    actor: actors[index],
                    onDelete: () {
                      actorsController.removeActorByIndex(index);
                    },
                  );
                },
              ),
      );
    });
  }

  Widget profileCard(String photoSid, String name, int id,
      {actor, Function()? onDelete}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            elevation: 5,
            child: Container(
              width: 162,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => MyRouteDelegate.of(context).push(
                      AppRoutes.actor,
                      args: {'id': actor.id, 'title': actor.name},
                      removeSamePath: true,
                    ),
                    child: ActorAvatar(
                        width: 100, height: 100, photoSid: photoSid),
                  ),
                  const SizedBox(height: 8),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  UserFavoritesActorConsumer(
                    id: id,
                    info: actor,
                    child: (isLiked, handleLike) => InkWell(
                      onTap: handleLike,
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: isLiked
                              ? const Color(0xfff1f1f2)
                              : const Color(0xfffe2c55),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isLiked ? '已關注' : '+ 關注',
                          style: TextStyle(
                            fontSize: 13,
                            color: isLiked
                                ? const Color(0xff161823)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
