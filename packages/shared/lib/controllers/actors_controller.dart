import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/actor_api.dart';
import '../models/actor.dart';
import 'actor_region_controller.dart';

final ActorApi actorApi = ActorApi();
final logger = Logger();

class ActorsController extends GetxController {
  var actors = <Actor>[].obs;
  Rx<int?> region = Rx<int?>(null);
  Rx<String?> name = Rx<String?>(null);
  Rx<int> sortBy = Rx<int>(0);

  final actorRegionController = Get.find<ActorRegionController>();

  ActorsController() {
    ever(actorRegionController.regions, (_) {
      if (actorRegionController.regions.isNotEmpty) {
        region.value = actorRegionController.regions[0].id;
        _fetchData();
      }
    });
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

  _fetchData() async {
    var res = await actorApi.getManyBy(
      page: 1,
      limit: 1000,
      region: region.value,
      name: name.value,
      sortBy: sortBy.value,
    );
    actors.value = res;
  }
}
