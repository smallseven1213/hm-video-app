import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/user_api.dart';
import '../models/actor.dart';

final userApi = UserApi();
final logger = Logger();

class UserFavoritesActorController extends GetxController {
  static const String _boxName = 'userFavoritesActor';
  late Box<String> box;
  var actors = <Actor>[].obs;

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
      actors.value = box.values.map((actorStr) {
        final actorJson = jsonDecode(actorStr) as Map<String, dynamic>;
        return Actor.fromJson(actorJson);
      }).toList();
    } else {
      await _fetchAndSaveCollection();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var actorList = await userApi.getFavoriteActor();
    actors.value = actorList;
    await _updateHive();
  }

  void addActor(Actor actor) async {
    if (actors.firstWhereOrNull((v) => v.id == actor.id) != null) {
      actors.removeWhere((v) => v.id == actor.id);
    }
    actors.add(actor);
    await _updateHive();
    userApi.addFavoriteActor(actor.id);
  }

  void removeActor(List<int> ids) async {
    actors.removeWhere((v) => ids.contains(v.id));
    await _updateHive();
    userApi.deleteActorFavorite(ids);
  }

  Future<void> _updateHive() async {
    await box.clear();
    for (var actor in actors) {
      final actorStr = jsonEncode(actor.toJson());
      await box.put(actor.id.toString(), actorStr);
    }
  }
}
