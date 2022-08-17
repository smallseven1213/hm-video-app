import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wgp_video_h5app/models/video.dart';

import '../providers/vod_provider.dart';

class VideosAPI {
  List<Video> listVideos = [];

  VideosAPI() {
    // load();
  }

  void load() async {
    await getVideoList();
  }

  Future<List<Video>> getVideoList() async {
    return await  Get.find<VodProvider>().getFollows();
  }
}
