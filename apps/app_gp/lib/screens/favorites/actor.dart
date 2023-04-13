import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';

class FavoritesActorScreen extends StatelessWidget {
  FavoritesActorScreen({Key? key}) : super(key: key);

  final userFavoritesActorController = Get.find<UserFavoritesActorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var actors = userFavoritesActorController.actors;
      return AlignedGridView.count(
        crossAxisCount: 2,
        itemCount: actors.length,
        itemBuilder: (BuildContext context, int index) {
          var actor = actors[index];
          return Container(
            color: Colors.green,
            child: Text(actor.name),
          );
        },
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 10.0,
      );
    });
  }
}
