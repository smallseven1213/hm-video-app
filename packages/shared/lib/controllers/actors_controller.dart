import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/actor_api.dart';
import '../models/actor.dart';
import 'actor_region_controller.dart';
import 'user_favorites_actor_controller.dart';

final ActorApi actorApi = ActorApi();
final logger = Logger();

class ActorsController extends GetxController {
  var actors = <Actor>[].obs;
  Rx<int?> region = Rx<int?>(null);
  Rx<String?> name = Rx<String?>(null);
  Rx<bool?> isRecommend = Rx<bool?>(null);
  Rx<int> sortBy = Rx<int>(0);
  Rx<int> limit = Rx<int>(1000);

  final actorRegionController = Get.find<ActorRegionController>();

  ActorsController({
    int? initialRegion,
    String? initialName,
    bool? initialIsRecommend,
    int? initialSortBy,
    int? initialLimit,
  }) {
    if (initialRegion != null) {
      region.value = initialRegion;
    } else {
      ever(actorRegionController.regions, (_) {
        if (actorRegionController.regions.isNotEmpty) {
          region.value = actorRegionController.regions[0].id;
        }
      });
    }
    if (initialName != null) {
      name.value = initialName;
    }
    if (initialIsRecommend != null) {
      isRecommend.value = initialIsRecommend;
    }
    if (initialSortBy != null) {
      sortBy.value = initialSortBy;
    }
    if (initialLimit != null) {
      limit.value = initialLimit;
    }
    _fetchData();
  }

  // 提供给外部的方法，以改变region并重新获取数据
  void setRegion(int? newRegion) {
    region.value = newRegion;
    _fetchData();
  }

  // 提供给外部的方法，以改变name并重新获取数据
  void setName(String? newName) {
    name.value = newName;
    _fetchData();
  }

  // 提供给外部的方法，以改变sortBy并重新获取数据
  void setSortBy(int newSortBy) {
    sortBy.value = newSortBy;
    _fetchData();
  }

  // 提供给外部的方法，以改变isRecommend并重新获取数据
  void setIsRecommend(bool newIsRecommend) {
    isRecommend.value = newIsRecommend;
    _fetchData();
  }

  // 提供给外部的方法，根据指定的index删除actors中的某一条数据
  void removeActorByIndex(int index) {
    if (index >= 0 && index < actors.length) {
      actors.removeAt(index);
    } else {
      logger.e("Index out of bounds: $index");
    }
  }

  // 這個方法將被用來刷新未關注演員的列表
  void fetchUnfollowedActors() {
    final UserFavoritesActorController userFavoritesActorController =
        Get.find<UserFavoritesActorController>();
    _fetchData().then((_) {
      actors.value = actors
          .where(
              (actor) => !userFavoritesActorController.isActorLiked(actor.id))
          .toList();
    });
  }

  _fetchData() async {
    var res = await actorApi.getManyBy(
      page: 1,
      limit: limit.value,
      region: region.value,
      name: name.value,
      sortBy: sortBy.value,
      isRecommend: isRecommend.value,
    );
    actors.value = res;
  }
}
