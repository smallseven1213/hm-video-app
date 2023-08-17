import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/modules/list_editor/list_editor_consumer.dart';
import 'package:shared/modules/list_editor/list_editor_provider.dart';
import 'package:shared/modules/list_editor/list_editor_toggle_editing_button.dart';

import '../screens/collection/short.dart';
import '../screens/collection/video.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_page_panel.dart';
import '../widgets/tab_bar.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  CollectionPageState createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
  final UserVodCollectionController userVodCollectionController =
      Get.find<UserVodCollectionController>();
  final UserShortCollectionController userShortCollectionController =
      Get.find<UserShortCollectionController>();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListEditorProvider(
        tag: ListEditorCategory.collection,
        child: (reset) => Scaffold(
              appBar: CustomAppBar(
                title: '我的收藏',
                actions: [
                  ListEditorToggleEditingButton(
                      tag: ListEditorCategory.collection,
                      child: ListEditorConsumer(
                        tag: ListEditorCategory.collection,
                        child: (isEditing, _1, _2, _3) => Text(
                          isEditing ? '取消' : '編輯',
                          style: const TextStyle(color: Color(0xff00B0D4)),
                        ),
                      )),
                ],
                bottom: GSTabBar(
                  tabs: const ['長視頻', '短視頻'],
                  controller: _tabController,
                  onTabChange: (p0) => reset(),
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      CollectionVideo(),
                      CollectionShortScreen(),
                    ],
                  ),
                  ListEditorConsumer(
                    tag: ListEditorCategory.collection,
                    child: (isEditing, selectedIds, removeBoundData,
                            saveBoundData) =>
                        ListPagePanelWidget(
                      isEditing: isEditing,
                      hasSelectedAny: selectedIds.isNotEmpty,
                      onSelectButtonClick: () {
                        if (_tabController.index == 0) {
                          var allData = userVodCollectionController.videos;
                          saveBoundData(allData.map((e) => e.id).toList());
                        } else if (_tabController.index == 1) {
                          var allData = userShortCollectionController.data;
                          saveBoundData(allData.map((e) => e.id).toList());
                        }
                      },
                      onDeleteButtonClick: () {
                        if (_tabController.index == 0) {
                          userVodCollectionController.removeVideo(selectedIds);
                          removeBoundData(selectedIds);
                        } else if (_tabController.index == 1) {
                          userShortCollectionController
                              .removeVideo(selectedIds);
                          removeBoundData(selectedIds);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ));
  }
}
