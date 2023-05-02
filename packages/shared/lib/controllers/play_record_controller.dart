import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';

final UserApi userApi = UserApi();
final logger = Logger();
const String prefsKey = 'playrecord';

class PlayRecordController extends GetxController {
  final playRecord = <VideoDatabaseField>[].obs;
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _initialData();
    Get.find<AuthController>().token.listen((event) {
      _initialData();
    });
  }

  void _initialData() async {
    logger.i('=====PLAYRECORD=====222');
    try {
      prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(prefsKey)) {
        final jsonData =
            jsonDecode(prefs.getString(prefsKey)!) as List<dynamic>;
        playRecord.value = jsonData
            .map<VideoDatabaseField>((videoJson) =>
                VideoDatabaseField.fromJson(videoJson as Map<String, dynamic>))
            .toList();
        logger.i('INITIAL=======prefs 2222');
      }
    } catch (error) {
      logger.e(error);
    }
  }

  void addPlayRecord(VideoDatabaseField video) async {
    if (playRecord.firstWhereOrNull((v) => v.id == video.id) != null) {
      playRecord.removeWhere((v) => v.id == video.id);
    }
    playRecord.add(video);
    logger.i('=====CREATE=====\n ${video.id} \n ${video.toJson()}');
    await _updatePrefs();
  }

  void removePlayRecord(List<int> ids) async {
    playRecord.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      playRecord.removeWhere((v) => v.id == id);
    }
    await _updatePrefs();
  }

  VideoDatabaseField? getById(int id) {
    return playRecord.firstWhereOrNull((video) => video.id == id);
  }

  Future<void> _updatePrefs() async {
    final jsonData = playRecord.map((video) => video.toJson()).toList();
    await prefs.setString(prefsKey, jsonEncode(jsonData));
  }
}
