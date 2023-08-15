import 'package:get/get.dart';

import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';

class UserTabController<T> {
  final T controller;

  UserTabController(this.controller);
}

final Map<String, UserTabController<dynamic>> userTabControllers = {
  'collection': UserTabController(Get.find<UserVodCollectionController>()),
  'short_collection':
      UserTabController(Get.find<UserShortCollectionController>()),
};
