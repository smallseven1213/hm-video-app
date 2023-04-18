import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/video_database_field.dart';
import '../models/vod.dart';

final userApi = UserApi();
final logger = Logger();

class UserFavoritesVideoController extends GetxController {
  static const String _prefsKey = 'userFavoritesVideo';
  late SharedPreferences prefs;
  var videos = <VideoDatabaseField>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_prefsKey)) {
      final jsonData = jsonDecode(prefs.getString(_prefsKey)!) as List<dynamic>;
      videos.value = jsonData
          .map<VideoDatabaseField>((videoJson) =>
              VideoDatabaseField.fromJson(videoJson as Map<String, dynamic>))
          .toList();
    } else {
      await _fetchAndSaveCollection();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var blockData = await userApi.getFavoriteVideo();
    videos.value = blockData.vods
        .map((video) => VideoDatabaseField(
              id: video.id,
              title: video.title,
              coverHorizontal: video.coverHorizontal!,
              coverVertical: video.coverVertical!,
              timeLength: video.timeLength!,
              tags: video.tags!,
              videoViewTimes: video.videoViewTimes!,
              // detail: video.detail,
            ))
        .toList();
    await _updatePrefs();
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
    await _updatePrefs();
    userApi.addFavoriteVideo(video.id);
  }

  // removeVideo from collection
  void removeVideo(List<int> ids) async {
    videos.removeWhere((v) => ids.contains(v.id));
    await _updatePrefs();
    userApi.deleteFavoriteVideo(ids);
  }

  Future<void> _updatePrefs() async {
    final jsonData = videos.map((video) => video.toJson()).toList();
    await prefs.setString(_prefsKey, jsonEncode(jsonData));
  }
}
