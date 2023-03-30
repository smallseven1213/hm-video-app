import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/collection/panel.dart';
import '../widgets/video_preview.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({Key? key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final UserCollectionController userCollectionController =
      Get.find<UserCollectionController>();
  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'user_video_collection');

  @override
  void dispose() {
    listEditorController.clearSelected();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '我的收藏',
        actions: [
          Obx(() => TextButton(
              onPressed: () {
                listEditorController.toggleEditing();
              },
              child: Text(
                listEditorController.isEditing.value ? '取消' : '編輯',
                style: const TextStyle(color: Color(0xff00B0D4)),
              )))
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            var videos = userCollectionController.videos;
            return AlignedGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 2,
              itemCount: userCollectionController.videos.length,
              itemBuilder: (BuildContext context, int index) =>
                  Obx(() => VideoPreviewWidget(
                        id: videos[index].detail?.id ?? videos[index].id,
                        isEditing: listEditorController.isEditing.value,
                        isSelected: listEditorController.selectedIds
                            .contains(videos[index].id),
                        onEditingTap: () {
                          listEditorController.toggleSelected(videos[index].id);
                        },
                        title: videos[index].title,
                        tags: videos[index].tags,
                        timeLength: videos[index].timeLength,
                        coverHorizontal: videos[index].coverHorizontal,
                        coverVertical: videos[index].coverVertical,
                        videoViewTimes: videos[index].videoViewTimes,
                        detail: videos[index].detail,
                      )),
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 10.0,
            );
          }),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PanelWidget(),
          ),
        ],
      ),
    );
  }
}
