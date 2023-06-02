import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/vod.dart';

final UserApi userApi = UserApi();
final logger = Logger();
// const String prefsKey = 'playrecord';

class PlayRecordController extends GetxController {
  final String _boxName;
  Future<Box<String>> boxFuture;
  var data = <Vod>[].obs;

  PlayRecordController({required String tag})
      : _boxName = 'playRecord_$tag',
        boxFuture = Hive.openBox<String>('playRecord_$tag');

  @override
  void onInit() {
    super.onInit();
    _init();
    Get.find<AuthController>().token.listen((event) {
      _init();
    });
  }

  Future<void> _init() async {
    var box = await boxFuture;

    if (box.isNotEmpty) {
      data.value = box.values.map((videoStr) {
        final videoJson = jsonDecode(videoStr) as Map<String, dynamic>;
        return Vod.fromJson(videoJson);
      }).toList();
    }
  }

  void addPlayRecord(Vod video) async {
    logger.i('PLAYRECORD TRACE: ADD ${video.toJson}');
    if (data.firstWhereOrNull((v) => v.id == video.id) != null) {
      data.removeWhere((v) => v.id == video.id);
    }
    data.insert(0, video);
    logger.i('PLAYRECORD TRACE: ${data.length}');
    await _updateHive();
  }

  void removeVideo(List<int> ids) async {
    data.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      data.removeWhere((v) => v.id == id);
    }
    await _updateHive();
  }

  Vod? getById(int id) {
    return data.firstWhereOrNull((video) => video.id == id);
  }

  Future<void> _updateHive() async {
    var box = await boxFuture;
    await box.clear();
    logger.i('PLAYRECORD TRACE: ${data.length}');
    for (var video in data) {
      final videoStr = jsonEncode(video.toJson());
      await box.put(video.id.toString(), videoStr);
    }
  }
}
