import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/list_page_panel.dart';
import '../widgets/no_data.dart';
import '../widgets/video_preview_with_edit.dart';

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
    listEditorController.closeEditing();
    super.dispose();
  }

  void _handleSelectAll() {
    var allData = userCollectionController.videos;
    listEditorController.saveBoundData(allData.map((e) => e.id).toList());
  }

  void _handleDeleteAll() {
    var selectedIds = listEditorController.selectedIds.toList();
    userCollectionController.removeVideo(selectedIds);
    listEditorController.removeBoundData(selectedIds);
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
            logger.i('RENDER BOX: Testing Page');
            var videos = userCollectionController.videos;
            if (videos.isEmpty) {
              return const NoDataWidget();
            }
            return AlignedGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 2,
              itemCount: userCollectionController.videos.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoPreviewWithEditWidget(
                  id: videos[index].id,
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
                  // detail: videos[index].detail,
                );
              },
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 10.0,
            );
          }),
          ListPagePanelWidget(
              listEditorController: listEditorController,
              onSelectButtonClick: _handleSelectAll,
              onDeleteButtonClick: _handleDeleteAll),
        ],
      ),
    );
  }
}
