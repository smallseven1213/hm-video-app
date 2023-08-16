import 'package:app_51ss/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/modules/user/user_tab_scaffold.dart';

import '../config/user_tab.dart';
import '../screens/collection/short.dart';
import '../screens/collection/video.dart';

// TODO: 確認編輯功能
class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  CollectionPageState createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
  UserVodCollectionController vodController =
      userTabControllers['collection']!.controller;
  UserShortCollectionController shortController =
      userTabControllers['short_collection']!.controller;

  final ListEditorController listEditorController =
      userTabControllers['list_editor_collection']!.controller;
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
      var allData = vodController.videos;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    } else if (_tabController.index == 1) {
      var allData = shortController.data;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    }
  }

  void _handleDeleteAll() {
    if (_tabController.index == 0) {
      var selectedIds = listEditorController.selectedIds.toList();
      vodController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    } else if (_tabController.index == 1) {
      var selectedIds = listEditorController.selectedIds.toList();
      shortController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: CustomAppBar(
            title: '我的收藏',
            actions: [
              Obx(() => TextButton(
                  onPressed: () {
                    listEditorController.toggleEditing();
                  },
                  child: Text(
                    listEditorController.isEditing.value ? '取消' : '編輯',
                    style: const TextStyle(color: Colors.white),
                  )))
            ],
          ),
          body: UserTabScaffold(
            tabs: const ['長視頻', '短視頻'],
            tabViews: [CollectionVideo(), CollectionShortScreen()],
            onTabChanged: () {
              listEditorController.clearSelected();
              listEditorController.isEditing.value = false;
            },
            listEditorController: listEditorController,
            onSelectButtonClick: _handleSelectAll,
            onDeleteButtonClick: _handleDeleteAll,
          )),
    );
  }
}
