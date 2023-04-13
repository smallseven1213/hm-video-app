import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../apis/user_api.dart';
import '../models/actor.dart';
import '../models/video_database_field.dart';

final userApi = UserApi();

class UserFavoritesActorController extends GetxController {
  static const String _boxName = 'userFavoritesActor';
  late Box<Actor> _userFavoritesActorBox;
  var actors = <Actor>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _userFavoritesActorBox = await Hive.openBox<Actor>(_boxName);

    if (_userFavoritesActorBox.isEmpty) {
      await _fetchAndSaveCollection();
    } else {
      actors.value = _userFavoritesActorBox.values.toList();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var actorList = await userApi.getFavoriteActor();

    for (Actor actor in actorList) {
      await _userFavoritesActorBox.put(actor.id, actor);
      actors.add(actor);
    }
  }

  void addActor(Actor actor) async {
    if (actors.firstWhereOrNull((v) => v.id == actor.id) != null) {
      actors.removeWhere((v) => v.id == actor.id);
    }
    actors.add(actor);
    await _userFavoritesActorBox.put(actor.id, actor);
    userApi.addFavoriteActor(actor.id);
  }

  void removeActor(List<int> ids) async {
    actors.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      await _userFavoritesActorBox.delete(id);
    }
    userApi.deleteActorFavorite(ids);
  }
}
