import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';
import '../models/vod.dart';

final userApi = UserApi();
final logger = Logger();

class UserFavoritesVideoController extends GetxController {
  static const String _boxName = 'userFavoritesVideo';
  late Box<VideoDatabaseField> _userFavoritesVideoBox;
  var videos = <VideoDatabaseField>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _userFavoritesVideoBox = await Hive.openBox<VideoDatabaseField>(_boxName);

    if (_userFavoritesVideoBox.isEmpty) {
      await _fetchAndSaveCollection();
    } else {
      logger.i(_userFavoritesVideoBox.values);
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
        // detail: video.detail,
      );

      await _userFavoritesVideoBox.put(video.id, videoDatabaseField);
      videos.add(videoDatabaseField);
    }
  }

  // addVideo to collection
  void addVideo(Vod video) async {
    logger.i(video.toJson());
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
    logger.i(formattedVideo.toJson());
    videos.add(formattedVideo);
    await _userFavoritesVideoBox.put(video.id, formattedVideo);
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
