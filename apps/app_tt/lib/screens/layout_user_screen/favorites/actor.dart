import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/circle_sidimage_text_item.dart';
import '../../../widgets/no_data.dart';

class FavoritesActorScreen extends StatelessWidget {
  FavoritesActorScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.favorites.toString());
  final userFavoritesActorController = Get.find<UserFavoritesActorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var actors = userFavoritesActorController.actors;
      if (actors.isEmpty) {
        return const NoDataWidget();
      }
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 8, left: 8),
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: PrimaryScrollController.of(context),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final Size size = MediaQuery.of(context).size;
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom:
                            8.0), // Used to replicate 'separatorBuilder' in ListView
                    child: Wrap(
                      children: List.generate(5, (i) {
                        final int actorIndex = index * 5 + i;
                        if (actorIndex < actors.length) {
                          var actor = actors[actorIndex];
                          return SizedBox(
                            width: (size.width - 16) / 5,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (listEditorController.isEditing.value) {
                                    listEditorController
                                        .toggleSelected(actor.id);
                                  } else {
                                    MyRouteDelegate.of(context).push(
                                      AppRoutes.actor,
                                      args: {
                                        'id': actor.id,
                                        'title': actor.name
                                      },
                                      removeSamePath: true,
                                    );
                                  }
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
                                            visible: listEditorController
                                                    .isEditing.value &&
                                                listEditorController.selectedIds
                                                    .contains(actor.id),
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/images/video_selected.png'),
                                              width: 20,
                                              height: 20,
                                            )))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(width: (size.width - 16) / 5);
                        }
                      }),
                    ),
                  );
                },
                childCount: (actors.length / 5)
                    .ceil(), // This is important to define the number of 'Wrap' widgets in the list
              ),
            ),
          ],
        ),
      );
    });
  }
}
