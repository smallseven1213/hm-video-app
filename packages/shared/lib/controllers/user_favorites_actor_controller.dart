import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/user_api.dart';
import '../models/actor.dart';
import '../models/video_database_field.dart';

final userApi = UserApi();
final logger = Logger();

class UserFavoritesActorController extends GetxController {
  static const String _prefsKey = 'userFavoritesActor';
  late SharedPreferences prefs;
  var actors = <Actor>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
    logger.i('CHECK ACTOR prefs $prefs');

    if (prefs.containsKey(_prefsKey)) {
      final jsonData = jsonDecode(prefs.getString(_prefsKey)!) as List<dynamic>;
      logger.i('CHECK ACTOR jsonData $jsonData');
      actors.value = jsonData
          .map<Actor>(
              (actorJson) => Actor.fromJson(actorJson as Map<String, dynamic>))
          .toList();
      logger.i('CHECK ACTOR obj ${actors.value}');
    } else {
      await _fetchAndSaveCollection();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var actorList = await userApi.getFavoriteActor();
    actors.value = actorList;
    await _updatePrefs();
  }

  void addActor(Actor actor) async {
    if (actors.firstWhereOrNull((v) => v.id == actor.id) != null) {
      actors.removeWhere((v) => v.id == actor.id);
    }
    actors.add(actor);
    await _updatePrefs();
    userApi.addFavoriteActor(actor.id);
  }

  void removeActor(List<int> ids) async {
    actors.removeWhere((v) => ids.contains(v.id));
    await _updatePrefs();
    userApi.deleteActorFavorite(ids);
  }

  Future<void> _updatePrefs() async {
    final jsonData = actors.map((actor) => actor.toJson()).toList();
    await prefs.setString(_prefsKey, jsonEncode(jsonData));
  }
}
