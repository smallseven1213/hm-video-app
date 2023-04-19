import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/widgets/sid_image.dart';

class FavoritesActorScreen extends StatelessWidget {
  FavoritesActorScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'favorites');
  final userFavoritesActorController = Get.find<UserFavoritesActorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var actors = userFavoritesActorController.actors;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AlignedGridView.count(
          crossAxisCount: 5,
          itemCount: actors.length,
          itemBuilder: (BuildContext context, int index) {
            var actor = actors[index];
            return InkWell(
              onTap: () {
                listEditorController.toggleSelected(actors[index].id);
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: SidImage(
                              key: ValueKey(actor.photoSid),
                              sid: actor.photoSid,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Obx(() => Visibility(
                              visible: listEditorController.isEditing.value &&
                                  listEditorController.selectedIds
                                      .contains(actors[index].id),
                              child: const Image(
                                image: AssetImage(
                                    'assets/images/video_selected.png'),
                                width: 40,
                                height: 40,
                              ))),
                        )
                      ],
                    ),
                  ),
                  Text(
                    actor.name,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            );
          },
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 10.0,
        ),
      );
    });
  }
}
