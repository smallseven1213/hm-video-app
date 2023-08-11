import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';

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
      Get.find<ListEditorController>(tag: 'collection');
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
      // appBar: CustomAppBar(
      //   title: '我的收藏',
      //   actions: [
      //     Obx(() => TextButton(
      //         onPressed: () {
      //           listEditorController.toggleEditing();
      //         },
      //         child: Text(
      //           listEditorController.isEditing.value ? '取消' : '編輯',
      //           style: const TextStyle(color: Color(0xff00B0D4)),
      //         )))
      //   ],
      //   bottom:
      //       GSTabBar(tabs: const ['長視頻', '短視頻'], controller: _tabController),
      // ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // CollectionVideo(),
              // CollectionShortScreen(),
            ],
          ),
          // ListPagePanelWidget(
          //   listEditorController: listEditorController,
          //   onSelectButtonClick: _handleSelectAll,
          //   onDeleteButtonClick: _handleDeleteAll,
          // ),
        ],
      ),
    );
  }
}
