// ActorController is a getx controller for the Actor class.

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/actor_api.dart';
import '../models/actor.dart';

final ActorApi actorApi = ActorApi();
final logger = Logger();

class ActorsController extends GetxController {
  var actors = <Actor>[].obs;
  Rx<int?> region = Rx<int?>(null);
  Rx<String?> name = Rx<String?>(null);
  Rx<int> sortBy = Rx<int>(0);

  ActorsController() {
    _fetchData();
    ever(region, (_) => _fetchData());
    ever(name, (_) => _fetchData());
    ever(sortBy, (_) => _fetchData());
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
