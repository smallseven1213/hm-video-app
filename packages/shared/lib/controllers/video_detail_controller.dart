import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/index.dart';

import 'system_config_controller.dart';

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
      fetchVideoDetail(videoId);
      isLoading.value = false;
    } catch (error) {
      logger.i(error);
    }
  }

  Future<void> fetchVideoUrl(int videoId) async {
    try {
      Vod videoFromApi = await vodApi.getVodUrl(videoId);
      videoUrl.value = getVideoUrl(videoFromApi.videoUrl)!;
      video.value = videoFromApi;
      _videoUrlReady.complete();
    } catch (error) {
      logger.i(error);
      _videoUrlReady.completeError(error);
    }
  }

  Future<void> fetchVideoDetail(int videoId) async {
    try {
      Vod videoDetailFromApi = await vodApi.getVodDetail(videoId);
      videoDetail.value = videoDetailFromApi;
      videoUrl.value = getVideoUrl(videoDetailFromApi.videoUrl)!;
      _videoUrlReady.complete();
    } catch (error) {
      logger.i(error);
      _videoUrlReady.completeError(error);
    }
  }
}
