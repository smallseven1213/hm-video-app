import 'package:app_wl_id1/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/enums/list_editor_category.dart';

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
  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.collection.toString());
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        listEditorController.clearSelected();
        listEditorController.isEditing.value = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    listEditorController.closeEditing();
    super.dispose();
  }

  void _handleSelectAll() {
    if (_tabController.index == 0) {
      var allData = userVodCollectionController.videos;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    } else if (_tabController.index == 1) {
      var allData = userShortCollectionController.data;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    }
  }

  void _handleDeleteAll() {
    if (_tabController.index == 0) {
      var selectedIds = listEditorController.selectedIds.toList();
      userVodCollectionController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    } else if (_tabController.index == 1) {
      var selectedIds = listEditorController.selectedIds.toList();
      userShortCollectionController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: I18n.collectPlaylist,
        actions: [
          Obx(() => TextButton(
              onPressed: () {
                listEditorController.toggleEditing();
              },
              child: Text(
                listEditorController.isEditing.value
                    ? I18n.cancel
                    : I18n.editTranslation,
                style: const TextStyle(color: Color(0xff00B0D4)),
              )))
        ],
        bottom: GSTabBar(
            tabs: [I18n.longVideo, I18n.shortVideo],
            controller: _tabController),
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
