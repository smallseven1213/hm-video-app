import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:app_gs/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_actor_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';
import '../screens/favorites/short.dart';
import '../widgets/button.dart';
import '../screens/favorites/video.dart';
import '../screens/favorites/actor.dart';
import '../widgets/list_page_panel.dart';

const tabs = ['長視頻', '短視頻', '演員'];

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        listEditorController.clearSelected();
        listEditorController.isEditing.value = false;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    listEditorController.clearSelected();
    listEditorController.isEditing.value = false;
    super.dispose();
  }

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'favorites');
  final userFavoritesActorController = Get.find<UserFavoritesActorController>();
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();
  final userFavoritesShortController = Get.find<UserFavoritesShortController>();

  void _handleSelectAll() {
    if (_tabController.index == 0) {
      var allData = userFavoritesVideoController.videos;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    } else if (_tabController.index == 1) {
      var allData = userFavoritesShortController.data;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    } else {
      var allData = userFavoritesActorController.actors;
      listEditorController.saveBoundData(allData.map((e) => e.id).toList());
    }
  }

  void _handleDeleteAll() {
    if (_tabController.index == 0) {
      var selectedIds = listEditorController.selectedIds.toList();
      userFavoritesVideoController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    } else if (_tabController.index == 1) {
      var selectedIds = listEditorController.selectedIds.toList();
      userFavoritesShortController.removeVideo(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    } else {
      var selectedIds = listEditorController.selectedIds.toList();
      userFavoritesActorController.removeActor(selectedIds);
      listEditorController.removeBoundData(selectedIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: '我的喜歡',
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
          bottom: GSTabBar(tabs: tabs, controller: _tabController),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                FavoritesVideoScreen(),
                FavoritesShortScreen(),
                FavoritesActorScreen(),
              ],
            ),
            ListPagePanelWidget(
                listEditorController: listEditorController,
                onSelectButtonClick: _handleSelectAll,
                onDeleteButtonClick: _handleDeleteAll),
          ],
        ));
  }
}
