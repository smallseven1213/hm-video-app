import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/models/index.dart';

final logger = Logger();

String? getVideoUrl(String? videoUrl) {
  final systemConfigController = Get.find<SystemConfigController>();
  if (videoUrl != null && videoUrl.isNotEmpty) {
    String uri = videoUrl.replaceAll('\\', '/').replaceAll('//', '/');
    if (uri.startsWith('http')) {
      return uri;
    }
    String id = uri.substring(uri.indexOf('/') + 1);
    return '${systemConfigController.vodHost.value}/$id/$id.m3u8';
  }
  return null;
}

class ShortVideoDetailController extends GetxController {
  VodApi vodApi = VodApi();
  final int videoId;
  var videoUrl = ''.obs;
  var isLoading = true.obs;
  var videoCollects = 0.obs;
  var videoFavorites = 0.obs;

  var _testCount = 0;

  var videoDetail = Rx<ShortVideoDetail?>(null);
  var video = Rx<Vod?>(null);

  ShortVideoDetailController(this.videoId);

  @override
  void onInit() async {
    super.onInit();
    ever(videoDetail, (_) {
      if (videoDetail.value != null) {
        videoCollects.value = videoDetail.value!.collects!;
        videoFavorites.value = videoDetail.value!.favorites;
      }
    });
    await mutateAll();
  }

  Future<void> mutateAll() async {
    await Future.wait([
      fetchVideoUrl(videoId),
      fetchVideoDetail(videoId),
    ]);

    isLoading.value = false;
  }

  Future<void> fetchVideoUrl(int videoId) async {
    _testCount++;
    try {
      Vod videoFromApi = await vodApi.getVodUrl(videoId);

      if (videoFromApi.videoUrl == null || videoFromApi.videoUrl!.isEmpty) {
        logger.i('Video URL from API is null or empty');
      } else {
        // var tmpVideoUrl =
        //     'wgp-video-prod-encrypt-videos\\preview_c5b20e338a09401a98a8e76b642675b1';
        // if (_testCount > 1) {
        //   tmpVideoUrl =
        //       'wgp-video-prod-encrypt-videos\\149e82c61f6b4824914d59dd258440ea';
        // }
        var videoUrlFormatted = getVideoUrl(videoFromApi.videoUrl);
        // for testing , always give wgp-video-prod-encrypt-videos\\preview_c5b20e338a09401a98a8e76b642675b1
        // var videoUrlFormatted = getVideoUrl(tmpVideoUrl);
        logger.i(_testCount);
        if (videoUrlFormatted != null) {
          videoUrl.value = videoUrlFormatted;
          video.value = videoFromApi;
        } else {
          logger.i('Formatted Video URL is null');
        }
      }
    } catch (error) {
      logger.i(error);
    }
  }

  Future<void> fetchVideoDetail(int videoId) async {
    try {
      ShortVideoDetail videoDetailFromApi =
          await vodApi.getShortVideoDetailById(videoId);
      videoDetail.value = videoDetailFromApi;
    } catch (error) {
      logger.i(error);
    }
  }

  void updateCollects(int change) {
    if (isClosed) return;
    int newCollects = videoCollects.value + change;
    videoCollects.value = newCollects;
  }

  void updateFavorites(int change) {
    if (isClosed) return;
    int newFavorites = videoFavorites.value + change;
    logger.i('newFavorites: $newFavorites');
    videoFavorites.value = newFavorites;
  }
}
