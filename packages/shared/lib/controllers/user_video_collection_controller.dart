import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/user_api.dart';
import '../models/vod.dart';

final userApi = UserApi();

class UserVodCollectionController extends GetxController {
  static const String _boxName = 'userVideoCollection';
  late Box<String> box;
  var videos = <Vod>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
    Get.find<AuthController>().token.listen((event) {
      _init();
    });
  }

  Future<void> _init() async {
    box = await Hive.openBox<String>(_boxName);

    if (box.isNotEmpty) {
      videos.value = box.values.map((videoStr) {
        final videoJson = jsonDecode(videoStr) as Map<String, dynamic>;
        return Vod.fromJson(videoJson);
      }).toList();
    } else {
      await _fetchAndSaveCollection();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var blockData = await userApi.getVideoCollection();
    videos.value = blockData.vods
        .map((video) => Vod(
              video.id,
              video.title,
              coverHorizontal: video.coverHorizontal!,
              coverVertical: video.coverVertical!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              videoViewTimes: video.videoViewTimes!,
              // detail: video.detail,
            ))
        .toList();
    await _updateHive();
  }

  // addVideo to collection
  void addVideo(Vod video) async {
    if (videos.firstWhereOrNull((v) => v.id == video.id) != null) {
      videos.removeWhere((v) => v.id == video.id);
    }

    var formattedVideo = Vod(
      video.id,
      video.title,
      coverHorizontal: video.coverHorizontal!,
      coverVertical: video.coverVertical!,
      timeLength: video.timeLength!,
      tags: video.tags!,
      videoViewTimes: video.videoViewTimes!,
      // detail: video.detail,
    );

    // Insert the new Vod at the beginning of the list.
    videos.insert(0, formattedVideo);
    await _updateHive();
    userApi.addVideoCollection(video.id);
  }

  // removeVideo from collection
  void removeVideo(List<int> ids) async {
    videos.removeWhere((v) => ids.contains(v.id));
    await _updateHive();
    userApi.deleteVideoCollection(ids);
  }

  Future<void> _updateHive() async {
    await box.clear();
    for (var video in videos) {
      final videoStr = jsonEncode(video.toJson());
      await box.put(video.id.toString(), videoStr);
    }
  }
}
