import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/models/video_database_field.dart';

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
            var videos = userCollectionController.videos;
            if (videos.isEmpty) {
              return const NoDataWidget();
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: (videos.length / 2).ceil(),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8);
              },
              itemBuilder: (BuildContext context, int index) {
                logger.i('RENDER BOX Testing');
                var video1 = videos[index * 2];
                VideoDatabaseField? video2;
                if (index * 2 + 1 < videos.length) {
                  video2 = videos[index * 2 + 1];
                }
                return Row(
                  children: [
                    Expanded(
                      child: VideoPreviewWithEditWidget(
                        id: video1.id,
                        isEditing: listEditorController.isEditing.value,
                        isSelected: listEditorController.selectedIds
                            .contains(video1.id),
                        onEditingTap: () {
                          listEditorController.toggleSelected(video1.id);
                        },
                        title: video1.title,
                        tags: video1.tags,
                        timeLength: video1.timeLength,
                        coverHorizontal: video1.coverHorizontal,
                        coverVertical: video1.coverVertical,
                        videoViewTimes: video1.videoViewTimes,
                        // detail: video1.detail,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (video2 != null)
                      Expanded(
                        child: VideoPreviewWithEditWidget(
                          id: video2.id,
                          isEditing: listEditorController.isEditing.value,
                          isSelected: listEditorController.selectedIds
                              .contains(video2.id),
                          onEditingTap: () {
                            listEditorController.toggleSelected(video2!.id);
                          },
                          title: video2.title,
                          tags: video2.tags,
                          timeLength: video2.timeLength,
                          coverHorizontal: video2.coverHorizontal,
                          coverVertical: video2.coverVertical,
                          videoViewTimes: video2.videoViewTimes,
                          // detail: video2.detail,
                        ),
                      ),
                  ],
                );
              },
            );
          }),
          ListPagePanelWidget(
            listEditorController: listEditorController,
            onSelectButtonClick: _handleSelectAll,
            onDeleteButtonClick: _handleDeleteAll,
          ),
        ],
      ),
    );
  }
}
