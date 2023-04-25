import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/circle_sidimage_text_item.dart';
import '../../widgets/no_data.dart';

class FavoritesActorScreen extends StatelessWidget {
  FavoritesActorScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'favorites');
  final userFavoritesActorController = Get.find<UserFavoritesActorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var actors = userFavoritesActorController.actors;
      if (actors.isEmpty) {
        return const NoDataWidget();
      }
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
        child: AlignedGridView.count(
          crossAxisCount: 5,
          itemCount: actors.length,
          itemBuilder: (BuildContext context, int index) {
            var actor = actors[index];
            final Size size = MediaQuery.of(context).size;
            return InkWell(
              onTap: () {
                listEditorController.toggleSelected(actors[index].id);
              },
              child: Stack(
                children: [
                  CircleTextItem(
                      text: actor.name,
                      photoSid: actor.photoSid,
                      imageWidth: size.width * 0.15,
                      imageHeight: size.width * 0.15,
                      isRounded: true,
                      hasBorder: true),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Obx(() => Visibility(
                          visible: listEditorController.isEditing.value &&
                              listEditorController.selectedIds
                                  .contains(actors[index].id),
                          child: const Image(
                            image:
                                AssetImage('assets/images/video_selected.png'),
                            width: 20,
                            height: 20,
                          )))),
                ],
              ),
              // child: Column(
              //   children: [
              //     SizedBox(
              //       width: 80,
              //       height: 80,
              //       child: Stack(
              //         children: [
              //           ClipRRect(
              //             borderRadius: BorderRadius.circular(80),
              //             child: SidImage(
              //                 key: ValueKey(actor.photoSid),
              //                 sid: actor.photoSid,
              //                 width: 80,
              //                 height: 80,
              //                 fit: BoxFit.cover),
              //           ),
              // Positioned(
              //   right: -20,
              //   top: -20,
              //   child: Obx(() => Visibility(
              //       visible: listEditorController.isEditing.value &&
              //           listEditorController.selectedIds
              //               .contains(actors[index].id),
              //       child: const Image(
              //         image: AssetImage(
              //             'assets/images/video_selected.png'),
              //         width: 40,
              //         height: 40,
              //       ))),
              //           )
              //         ],
              //       ),
              //     ),
              //     Text(
              //       actor.name,
              //       style: TextStyle(color: Colors.white),
              //     )
              //   ],
              // ),
            );
          },
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 10.0,
        ),
      );
    });
  }
}
