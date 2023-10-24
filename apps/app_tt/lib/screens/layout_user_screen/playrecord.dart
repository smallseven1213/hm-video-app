import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/enums/play_record_type.dart';

import '../../widgets/list_page_panel.dart';
import 'playrecord/short.dart';
import 'playrecord/video.dart';
import 'shared/sub_tabbar.dart';

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
    return Stack(
      children: [
        CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: PrimaryScrollController.of(context),
          slivers: <Widget>[
            SubTabBar(
              editorTag: ListEditorCategory.playrecord,
              tabs: [I18n.longVideo, I18n.shortVideo],
              controller: _tabController,
              onSelectAll: () {},
            ),
            SliverFillRemaining(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  PlayRecordVideoScreen(),
                  PlayRecordShortScreen(),
                ],
              ),
            ),
          ],
        ),
        ListPagePanelWidget(
            listEditorController: listEditorController,
            onSelectButtonClick: _handleSelectAll,
            onDeleteButtonClick: _handleDeleteAll),
      ],
    );
  }
}
