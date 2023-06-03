import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/index.dart';
import 'package:shared/services/system_config.dart';

final systemConfig = SystemConfig();
final logger = Logger();

String? getVideoUrl(String? videoUrl) {
  if (videoUrl != null && videoUrl.isNotEmpty) {
    String uri = videoUrl.replaceAll('\\', '/').replaceAll('//', '/');
    if (uri.startsWith('http')) {
      return uri;
    }
    String id = uri.substring(uri.indexOf('/') + 1);
    return '${systemConfig.vodHost}/$id/$id.m3u8';
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

  var videoDetail = Rx<ShortVideoDetail?>(null);
  var video = Rx<Vod?>(null);
  final _videoUrlReady = Completer<void>();
  Future<void> get videoUrlReady => _videoUrlReady.future;

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
    try {
      Vod videoFromApi = await vodApi.getVodUrl(videoId);

      if (videoFromApi.videoUrl == null || videoFromApi.videoUrl!.isEmpty) {
        logger.i('Video URL from API is null or empty');
      } else {
        var videoUrlFormatted = getVideoUrl(videoFromApi.videoUrl);
        if (videoUrlFormatted != null) {
          videoUrl.value = videoUrlFormatted;
          video.value = videoFromApi;
          _videoUrlReady
              .complete(); // Complete the Future when videoUrl has a value.
        } else {
          logger.i('Formatted Video URL is null');
        }
      }
    } catch (error) {
      logger.i(error);
      _videoUrlReady.completeError(error);
    }
  }

  Future<void> fetchVideoDetail(int videoId) async {
    try {
      ShortVideoDetail _videoDetail =
          await vodApi.getShortVideoDetailById(videoId);
      videoDetail.value = _videoDetail;
    } catch (error) {
      logger.i(error);
    }
  }

  void updateCollects(int change) {
    int newCollects = videoCollects.value + change;
    videoCollects.value = newCollects;
  }

  void updateFavorites(int change) {
    int newFavorites = videoFavorites.value + change;
    logger.i('newFavorites: $newFavorites');
    videoFavorites.value = newFavorites;
  }
}
