import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:wgp_video_h5app/models/story_video_view.dart';
import 'package:wgp_video_h5app/models/video.dart';

import '../providers/vod_provider.dart';
import 'VideoLoader.dart';

class FollowsView extends StoryView {

  FollowsView () {
    onLoading();
  }
  onLoading() async {
    super.videoSource?.listVideos.addAll(await Get.find<VodProvider>().getFollows());
  }
}
