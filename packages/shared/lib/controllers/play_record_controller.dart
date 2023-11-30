import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/user_api.dart';
import '../models/vod.dart';

final UserApi userApi = UserApi();

class PlayRecordController extends GetxController {
  Future<Box<String>> boxFuture;
  var data = <Vod>[].obs;
  var activeTabId = 0.obs;

  PlayRecordController({required String tag})
      : boxFuture = Hive.openBox<String>('playRecord_$tag');

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
      var records = box.values.map((videoStr) {
        final videoJson = jsonDecode(videoStr) as Map<String, dynamic>;
        return Vod.fromJson(videoJson);
      }).toList();

      if (box.keys.length > 20) {
        for (var key in box.keys.skip(20)) {
          await box.delete(key);
        }
      }

      data.value = records.take(20).toList();
    }
  }

  void addPlayRecord(Vod video) async {
    if (data.firstWhereOrNull((v) => v.id == video.id) != null) {
      data.removeWhere((v) => v.id == video.id);
    }

    // If the list already has 20 elements, remove the last one.
    if (data.length >= 20) {
      data.removeLast();
    }

    // Add the new record at the beginning of the list.
    data.insert(0, video);

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
    var dataCopy = List<Vod>.from(data);

    for (var video in dataCopy) {
      final videoStr = jsonEncode(video.toJson());
      await box.put(video.id.toString(), videoStr);
    }
  }
}
