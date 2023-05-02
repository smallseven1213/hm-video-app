import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/models/vod.dart';
import '../apis/vod_api.dart';
import '../models/block_vod.dart';

final vodApi = VodApi();

class BlockVideosByCategoryController extends GetxController {
  String excludeId;
  String actorId;
  String tagId;
  String internalTagId;

  final RxList<Vod> videoByInternalTag = <Vod>[].obs;
  final RxList<Vod> videoByTag = <Vod>[].obs;
  final RxList<Vod> videoByActor = <Vod>[].obs;

  BlockVideosByCategoryController({
    required this.tagId,
    required this.excludeId,
    required this.actorId,
    required this.internalTagId,
  });

  @override
  void onInit() async {
    super.onInit();
    print('@@@@@@ init');
    mutateAll();

    Get.find<AuthController>().token.listen((event) {
      mutateAll();
    });
  }

  Future mutateAll() async {
    BlockVod actorVideos = BlockVod([], 0);
    final internalTagVideos =
        await vodApi.getVideoByInternalTag(excludeId, internalTagId);
    final tagVideos =
        await vodApi.getVideoByTags(excludeId: excludeId, tagId: tagId);
    if (actorId != '') {
      actorVideos = await vodApi.getVideoByActorId(actorId);
    }

    // print('log internalTagVideos: ${internalTagVideos.vods}');
    // print('log tagVideos: ${tagVideos.vods}');
    // print('log actorVideos: ${actorVideos.vods}');

    // Assign fetched videos to respective observable lists
    videoByInternalTag.assignAll(internalTagVideos.vods);
    videoByTag.assignAll(tagVideos.vods);
    videoByActor.assignAll(actorVideos.vods);
  }
}
