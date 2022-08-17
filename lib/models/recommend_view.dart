import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wgp_video_h5app/models/story_video_view.dart';
import 'package:wgp_video_h5app/models/video.dart';

import '../providers/vod_provider.dart';

class RecommendView extends StoryView {
  RecommendView () {
    onLoading();
  }
  onLoading() async {
    super.videoSource?.listVideos.addAll(await Get.find<VodProvider>().getRecommends());
  }

}
