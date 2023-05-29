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
  // var videoDetail = Vod(0, '').obs;
  var videoUrl = ''.obs;
  // var video = Video(id: 0, title: '').obs;

  var videoDetail = Rx<ShortVideoDetail?>(null);
  var video = Rx<Video?>(null);

  ShortVideoDetailController(this.videoId);

  @override
  void onInit() async {
    super.onInit();
    mutateAll();
  }

  void mutateAll() {
    fetchVideoUrl(videoId);
    fetchVideoDetail(videoId);
  }

  Future<void> fetchVideoUrl(int videoId) async {
    try {
      Video _video = await vodApi.getVodUrl(videoId);
      videoUrl.value = getVideoUrl(_video.videoUrl)!;
      video.value = _video;
    } catch (error) {
      logger.i(error);
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
}
