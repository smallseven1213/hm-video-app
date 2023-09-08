import 'package:get/get.dart';
import '../apis/vod_api.dart';
import '../models/vod.dart';

class VideoByInternalTagController extends GetxController {
  VodApi vodApi = VodApi();
  var data = <Vod>[].obs;
  String excludeId;
  String internalTagId;

  VideoByInternalTagController({
    required this.internalTagId,
    required this.excludeId,
  });

  @override
  void onInit() async {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    final result = await vodApi.getVideoByInternalTag(
      excludeId,
      internalTagId,
    );
    data.value = result.vods;
  }
}
