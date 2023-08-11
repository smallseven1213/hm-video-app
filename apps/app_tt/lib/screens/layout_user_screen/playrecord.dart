import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';

final logger = Logger();

class PlayRecordPage extends StatefulWidget {
  const PlayRecordPage({Key? key}) : super(key: key);

  @override
  PlayRecordPageState createState() => PlayRecordPageState();
}

class PlayRecordPageState extends State<PlayRecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: vodPlayRecordController.activeTabId.value,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        listEditorController.clearSelected();
        listEditorController.isEditing.value = false;

        vodPlayRecordController.activeTabId.value = _tabController.index;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    listEditorController.clearSelected();
    listEditorController.isEditing.value = false;
    super.dispose();
  }

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'playrecord');
  final vodPlayRecordController = Get.find<PlayRecordController>(tag: 'vod');
  final shortPlayRecordController =
      Get.find<PlayRecordController>(tag: 'short');

  void _handleSelectAll() {
    if (_tabController.index == 0) {
      var allData = vodPlayRecordController.data;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    } else {
      var allData = shortPlayRecordController.data;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    }
  }

  void _handleDeleteAll() {
    if (_tabController.index == 0) {
      var selectedIds = listEditorController.selectedIds.toList();
      vodPlayRecordController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    } else {
      var selectedIds = listEditorController.selectedIds.toList();
      shortPlayRecordController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   title: '我的足跡',
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
      //       TabBar(tabs: const ['長視頻', '短視頻'], controller: _tabController),
      // ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // PlayRecordVideoScreen(),
              // PlayRecordShortScreen(),
            ],
          ),
          // ListPagePanelWidget(
          //     listEditorController: listEditorController,
          //     onSelectButtonClick: _handleSelectAll,
          //     onDeleteButtonClick: _handleDeleteAll),
        ],
      ),
    );
  }
}
