import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';
import '../models/vod.dart';

final userApi = UserApi();

class UserCollectionController extends GetxController {
  static const String _boxName = 'userVideoCollection';
  late Box<VideoDatabaseField> _userCollectionBox;
  var videos = <VideoDatabaseField>[].obs;

  UserCollectionController() {
    _init();
  }

  Future<void> _init() async {
    _userCollectionBox = await Hive.openBox<VideoDatabaseField>(_boxName);

    if (_userCollectionBox.isEmpty) {
      await _fetchAndSaveCollection();
    } else {
      videos.value = _userCollectionBox.values.toList();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var blockData = await userApi.getVideoCollection();
    for (Vod video in blockData.vods) {
      var videoDatabaseField = VideoDatabaseField(
        id: video.id,
        title: video.title,
        coverHorizontal: video.coverHorizontal!,
        coverVertical: video.coverVertical!,
        timeLength: video.timeLength!,
        tags: video.tags!,
        videoViewTimes: video.videoViewTimes!,
        detail: jsonDecode(video.detail!),
      );
      await _userCollectionBox.put(video.id, videoDatabaseField);
      videos.add(videoDatabaseField);
    }
  }

  // addVideo to collection
  void addVideo(Vod video) async {
    if (videos.firstWhereOrNull((v) => v.id == video.id) != null) {
      videos.removeWhere((v) => v.id == video.id);
    }
    var formattedVideo = VideoDatabaseField(
      id: video.id,
      title: video.title,
      coverHorizontal: video.coverHorizontal!,
      coverVertical: video.coverVertical!,
      timeLength: video.timeLength!,
      tags: video.tags!,
      videoViewTimes: video.videoViewTimes!,
      // detail: video.detail == null || video.detail == ''
      //     ? {}
      //     : jsonDecode(video.detail!),
    );
    videos.add(formattedVideo);
    await _userCollectionBox.put(video.id, formattedVideo);
  }

  // removeVideo from collection
  void removeVideo(List<int> ids) async {
    videos.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      await _userCollectionBox.delete(id);
    }
  }
}
