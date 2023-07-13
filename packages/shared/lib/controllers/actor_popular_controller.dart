import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/actor_api.dart';
import '../models/actor_with_vods.dart';

final ActorApi actorApi = ActorApi();
final logger = Logger();

class ActorPopularController extends GetxController {
  var actors = <ActorWithVod>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

  ActorPopularController() {
    fetchData();
    Get.find<AuthController>().token.listen((event) {
      fetchData();
    });
  }

  fetchData() async {
    try {
      isLoading.value = true;
      isError.value = false;
      var res = await actorApi.getManyPopularActorBy(
        page: 1,
        limit: 10,
      );
      actors.value = res;
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
