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

class VideoDetailController extends GetxController {
  VodApi vodApi = VodApi();
  final int videoId;
  var videoUrl = ''.obs;
  var isLoading = true.obs;

  var videoDetail = Rx<Vod?>(null);
  var video = Rx<Vod?>(null);
  final _videoUrlReady = Completer<void>();
  Future<void> get videoUrlReady => _videoUrlReady.future;

  VideoDetailController(this.videoId);

  @override
  void onInit() async {
    super.onInit();
    await mutateAll();
  }

  Future<void> mutateAll() async {
    await Future.wait([
      fetchAllData(videoId),
    ]);

    isLoading.value = false;
  }

  Future<void> fetchAllData(int videoId) async {
    try {
      await Future.wait([
        fetchVideoUrl(videoId),
        fetchVideoDetail(videoId),
      ]);
      isLoading.value = false;
    } catch (error) {
      logger.i(error);
    }
  }

  Future<void> fetchVideoUrl(int videoId) async {
    try {
      Vod _video = await vodApi.getVodUrl(videoId);
      videoUrl.value = getVideoUrl(_video.videoUrl)!;
      video.value = _video;
      _videoUrlReady.complete();
    } catch (error) {
      logger.i(error);
      _videoUrlReady.completeError(error);
    }
  }

  Future<void> fetchVideoDetail(int videoId) async {
    Vod _videoDetail = await vodApi.getVodDetail(videoId);
    videoDetail.value = _videoDetail;
  }
}
