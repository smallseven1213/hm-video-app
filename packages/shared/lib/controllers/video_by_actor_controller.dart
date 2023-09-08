import 'package:get/get.dart';
import '../apis/vod_api.dart';
import '../models/vod.dart';

class VideoByActorController extends GetxController {
  VodApi vodApi = VodApi();
  var data = <Vod>[].obs;
  String actorId;
  String excludeId;

  VideoByActorController({
    required this.actorId,
    required this.excludeId,
  });

  @override
  void onInit() async {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    final result =
        await vodApi.getVideoByActorId(excludeId: excludeId, actorId: actorId);
    data.value = result.vods;
  }
}
