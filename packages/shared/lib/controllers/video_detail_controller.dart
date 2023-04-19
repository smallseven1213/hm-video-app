import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/index.dart';
import 'package:shared/services/system_config.dart';

final systemConfig = SystemConfig();

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
  var videoDetail = Vod(0, '').obs;
  var videoUrl = ''.obs;
  var video = Video(id: 0, title: '').obs;

  VideoDetailController(this.videoId);

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
      print(error);
    }
  }

  Future<void> fetchVideoDetail(int videoId) async {
    try {
      Vod _videoDetail = await vodApi.getVodDetail(videoId);
      videoDetail.value = _videoDetail;
    } catch (error) {
      print(error);
    }
  }
}
