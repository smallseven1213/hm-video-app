import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/enums/play_record_type.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

import '../screens/playrecord/short.dart';
import '../screens/playrecord/video.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_page_panel.dart';
import '../widgets/tab_bar.dart';

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
      Get.find<ListEditorController>(
          tag: ListEditorCategory.playrecord.toString());
  final vodPlayRecordController =
      Get.find<PlayRecordController>(tag: PlayRecordType.video.toString());
  final shortPlayRecordController =
      Get.find<PlayRecordController>(tag: PlayRecordType.short.toString());

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
      appBar: CustomAppBar(
        title: I18n.browseHistory,
        actions: [
          Obx(() => TextButton(
              onPressed: () {
                listEditorController.toggleEditing();
              },
              child: Text(
                listEditorController.isEditing.value
                    ? I18n.cancel
                    : I18n.editTranslation,
                style: const TextStyle(color: Colors.white),
              )))
        ],
        bottom: TabBarWidget(
            tabs: [I18n.longVideo, I18n.shortVideo],
            controller: _tabController),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              PlayRecordVideoScreen(),
              PlayRecordShortScreen(),
            ],
          ),
          ListPagePanelWidget(
              listEditorController: listEditorController,
              onSelectButtonClick: _handleSelectAll,
              onDeleteButtonClick: _handleDeleteAll),
        ],
      ),
    );
  }
}
