import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stacked/stacked.dart';
import 'package:wgp_video_h5app/models/video.dart';

import '../providers/vod_provider.dart';
import 'VideoLoader.dart';

class StoryView extends BaseViewModel {
  VideosAPI? videoSource = VideosAPI();
  int prevVideo = 0;
  int prevPrevVideo = 0;
  int actualScreen = 0;

  pauseCurrent() {
    pauseVideo(actualScreen);
  }

  playCurrent() {
    loadVideo(actualScreen);
  }

  changeVideo(index) async {
    print("changevideo" + this.runtimeType.toString());
    if (videoSource!.listVideos.length == 0) {
      return;
    }
    actualScreen = index;
    videoSource!.listVideos[index].play();
    if (index != prevVideo) {
      videoSource!.listVideos[prevVideo].pause();
    }

    if (videoSource!.listVideos.length >= index + 1) {
      videoSource!.listVideos[index + 1].loadController();
    }

    prevPrevVideo = prevVideo;
    prevVideo = index;
    notifyListeners();
  }

  void pauseVideo(int index) async {
    if (videoSource!.listVideos.length > index) {
      videoSource!.listVideos[index].pause();
    }
  }

  void loadVideo(int index) async {
    if (videoSource!.listVideos.length > index) {
      await videoSource!.listVideos[index].loadController().then((value) => {
            videoSource!.listVideos[index].controller?.play(),
            notifyListeners()
          });
    }
  }


  changeSource(List<Video> videos) {
    videoSource?.listVideos.forEach((element) {element.controller?.dispose();});
    videoSource?.listVideos.clear();
    prevVideo = 0;
    prevPrevVideo = 0;
    actualScreen = 0;
    videoSource?.listVideos.addAll(videos);
  }
}
