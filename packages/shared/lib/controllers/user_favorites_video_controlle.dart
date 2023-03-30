import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../apis/user_api.dart';
import '../models/channel_info.dart';
import '../models/video_database_field.dart';
import '../models/vod.dart';

final userApi = UserApi();

class UserFavoritesVideoController extends GetxController {
  static const String _boxName = 'userFavoritesVideo';
  late Box<VideoDatabaseField> _userFavoritesVideoBox;
  var videos = <VideoDatabaseField>[].obs;

  UserFavoritesVideoController() {
    _init();
  }

  Future<void> _init() async {
    _userFavoritesVideoBox = await Hive.openBox<VideoDatabaseField>(_boxName);

    if (_userFavoritesVideoBox.isEmpty) {
      await _fetchAndSaveCollection();
    } else {
      videos.value = _userFavoritesVideoBox.values.toList();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var blockData = await userApi.getFavoriteVideo();
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
      await _userFavoritesVideoBox.put(video.id, videoDatabaseField);
      videos.add(videoDatabaseField);
    }
  }

  // addVideo to collection
  void addVideo(VideoDatabaseField video) async {
    if (videos.firstWhereOrNull((v) => v.id == video.id) != null) {
      videos.removeWhere((v) => v.id == video.id);
    }
    videos.add(video);
    await _userFavoritesVideoBox.put(video.id, video);
    userApi.addFavoriteVideo(video.id);
  }

  // removeVideo from collection
  void removeVideo(List<int> ids) async {
    videos.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      await _userFavoritesVideoBox.delete(id);
    }
    userApi.deleteFavoriteVideo(ids);
  }
}
