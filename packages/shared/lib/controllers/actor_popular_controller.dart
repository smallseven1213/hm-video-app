import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/actor_api.dart';
import '../models/actor_with_vods.dart';

final ActorApi actorApi = ActorApi();
final logger = Logger();

class ActorPopularController extends GetxController {
  var actors = <ActorWithVod>[].obs;

  ActorPopularController() {
    _fetchData();
    Get.find<AuthController>().token.listen((event) {
      _fetchData();
    });
  }

  _fetchData() async {
    var res = await actorApi.getManyPopularActorBy(
      page: 1,
      limit: 10,
    );

    actors.value = res;
  }
}
