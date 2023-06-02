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

  VideoDetailController(this.videoId);

  @override
  void onInit() async {
    super.onInit();
    mutateAll();
  }

  void mutateAll() {
    fetchAllData(videoId);
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
    Vod _video = await vodApi.getVodUrl(videoId);
    videoUrl.value = getVideoUrl(_video.videoUrl)!;
    video.value = _video;
  }

  Future<void> fetchVideoDetail(int videoId) async {
    Vod _videoDetail = await vodApi.getVodDetail(videoId);
    videoDetail.value = _videoDetail;
  }
}
