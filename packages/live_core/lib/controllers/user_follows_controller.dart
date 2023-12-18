import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../apis/streamer_api.dart';
import '../apis/user_api.dart';
import '../models/live_api_response_base.dart';
import '../models/streamer.dart';

final userApi = UserApi();
final streamerApi = StreamerApi();
final logger = Logger();

class UserFollowsController extends GetxController {
  static const String _boxName = 'userFollows';
  late Box<String> box;
  var follows = <Streamer>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    box = await Hive.openBox<String>(_boxName);

    if (box.isNotEmpty) {
      follows.value = box.values.map((videoStr) {
        final videoJson = jsonDecode(videoStr) as Map<String, dynamic>;
        return Streamer.fromJson(videoJson);
      }).toList();
    } else {
      await _fetchAndSaveCollection();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    LiveApiResponseBase res = await userApi.getFollows();
    follows.value = res.data;
    await _updateHive();
  }

  void follow(Streamer streamer) async {
    if (follows.firstWhereOrNull((v) => v.id == streamer.id) != null) {
      follows.removeWhere((v) => v.id == streamer.id);
    }

    // Insert the new Vod at the beginning of the list.
    follows.insert(0, streamer);
    follows.refresh();

    await _updateHive();
    streamerApi.follow(streamer.id);
  }

  void unfollow(Streamer streamer) async {
    follows.removeWhere((v) => v.id == streamer.id);
    follows.refresh();

    await _updateHive();
    streamerApi.unfollow(streamer.id);
  }

  Future<void> _updateHive() async {
    await box.clear();
    for (var streamer in follows) {
      final followsStr = jsonEncode(streamer.toJson());
      await box.put(streamer.id.toString(), followsStr);
    }
    follows.refresh();
  }

  bool isFollowed(int streamerId) {
    return follows.any((streamer) => streamer.id == streamerId);
  }
}
