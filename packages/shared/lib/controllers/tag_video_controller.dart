import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';
import '../models/vod.dart';

final userApi = UserApi();

class TagVideoController extends GetxController {
  var videos = <VideoDatabaseField>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {}
}
