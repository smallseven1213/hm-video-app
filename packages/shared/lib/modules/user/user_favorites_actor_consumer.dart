import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/actor_controller.dart';
import '../../controllers/user_favorites_actor_controller.dart';
import '../../models/actor.dart';

class UserFavoritesActorConsumer extends StatelessWidget {
  final Widget Function(bool isLike, void Function()? handleLike) child;
  final Actor info;
  final int id;

  const UserFavoritesActorConsumer({
    Key? key,
    required this.child,
    required this.info,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserFavoritesActorController userFavoritesActorController =
        Get.find<UserFavoritesActorController>();

    return Obx(() {
      var isLiked = userFavoritesActorController.actors.any((e) => e.id == id);

      handleLike() {
        if (isLiked) {
          userFavoritesActorController.removeActor([id]);
          return;
        } else {
          userFavoritesActorController.addActor(info);
        }
      }

      return child(isLiked, handleLike);
    });
  }
}
