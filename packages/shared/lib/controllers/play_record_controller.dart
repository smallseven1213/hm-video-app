import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';

final UserApi userApi = UserApi();
final logger = Logger();
// const String prefsKey = 'playrecord';

class PlayRecordController extends GetxController {
  late final String _boxName;
  late Box<String> box;
  var videos = <VideoDatabaseField>[].obs;

  PlayRecordController({required String tag}) {
    _boxName = 'playRecord_$tag';
  }

  @override
  void onInit() {
    super.onInit();
    _init();
    Get.find<AuthController>().token.listen((event) {
      _init();
    });
  }

  Future<void> _init() async {
    box = await Hive.openBox<String>(_boxName);

    if (box.isNotEmpty) {
      videos.value = box.values.map((videoStr) {
        final videoJson = jsonDecode(videoStr) as Map<String, dynamic>;
        return VideoDatabaseField.fromJson(videoJson);
      }).toList();
    }
  }

  void addPlayRecord(VideoDatabaseField video) async {
    if (videos.firstWhereOrNull((v) => v.id == video.id) != null) {
      videos.removeWhere((v) => v.id == video.id);
    }
    videos.insert(0, video);
    await _updateHive();
  }

  void removeVideo(List<int> ids) async {
    videos.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      videos.removeWhere((v) => v.id == id);
    }
    await _updateHive();
  }

  VideoDatabaseField? getById(int id) {
    return videos.firstWhereOrNull((video) => video.id == id);
  }

  Future<void> _updateHive() async {
    await box.clear();
    for (var video in videos) {
      final videoStr = jsonEncode(video.toJson());
      await box.put(video.id.toString(), videoStr);
    }
  }
}
