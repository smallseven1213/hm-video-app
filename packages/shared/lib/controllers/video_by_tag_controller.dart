import 'package:get/get.dart';
import '../apis/vod_api.dart';
import '../models/vod.dart';

class VideoByTagController extends GetxController {
  VodApi vodApi = VodApi();
  var data = <Vod>[].obs;
  String tagId;
  String excludeId;

  VideoByTagController({
    required this.tagId,
    required this.excludeId,
  });

  @override
  void onInit() async {
    super.onInit();
    print('VideoByTagController onInit');
    fetchData();
  }

  Future<void> fetchData() async {
    final result =
        await vodApi.getVideoByTags(excludeId: excludeId, tagId: tagId);
    data.value = result.vods;
  }
}
