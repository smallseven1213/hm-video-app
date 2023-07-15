import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/vod.dart';

final UserApi userApi = UserApi();
final logger = Logger();

class SearchTempShortController extends GetxController {
  var data = <Vod>[].obs;

  SearchTempShortController();

  void addVideos(List<Vod> videos) async {
    data.value = videos;
  }

  void replaceVideos(List<Vod> videos) async {
    data.value = videos;
  }

  void removeVideos() async {
    data.value = [];
  }
}
