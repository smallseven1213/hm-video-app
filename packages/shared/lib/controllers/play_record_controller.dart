import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';

final UserApi userApi = UserApi();
final logger = Logger();
const String hiveKey = 'playrecord';

class PlayRecordController extends GetxController {
  final playRecord = <VideoDatabaseField>[].obs;
  late Box<VideoDatabaseField> playrecordBox;

  @override
  void onInit() {
    super.onInit();
    _initialData();
  }

  @override
  void onClose() {
    super.onClose();
    playrecordBox.close();
  }

  void _initialData() async {
    try {
      if (playrecordBox.isEmpty) {
        playrecordBox = await Hive.openBox<VideoDatabaseField>(hiveKey);
      }
      playRecord.value = playrecordBox.values.toList();
    } catch (error) {
      print(error);
    }
  }

  void addPlayRecord(VideoDatabaseField video) async {
    if (playRecord.firstWhereOrNull((v) => v.id == video.id) != null) {
      playRecord.removeWhere((v) => v.id == video.id);
    }
    playRecord.add(video);
    playrecordBox.put(video.id, video);
  }

  void removePlayRecord(List<int> ids) async {
    playRecord.removeWhere((v) => ids.contains(v.id));
    // for (var id in ids) {
    //   playRecord.removeWhere((v) => v.id == int.parse(id));
    //   playrecordBox.delete(int.parse(id));
    // }
  }

  VideoDatabaseField? getById(int id) {
    return playRecord.firstWhereOrNull((video) => video.id == id);
  }
}
