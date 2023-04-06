import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/index.dart';

class VideoDetailController extends GetxController {
  final int videoId;
  var videoDetail = Vod(0, '').obs;
  var videoUrl = ''.obs;

  VideoDetailController(this.videoId);

  @override
  void onInit() async {
    super.onInit();
    fetchVideoUrl(videoId);
  }

  Future<void> fetchVideoUrl(int videoId) async {
    VodApi vodApi = VodApi();
    Vod vod = await vodApi.getVodUrl(videoId);
    videoUrl.value = vod.getVideoUrl()!;
    videoDetail.value = vod;
  }
}
