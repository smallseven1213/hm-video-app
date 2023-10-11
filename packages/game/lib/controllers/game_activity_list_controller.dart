import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/models/game_activity.dart';
import 'package:shared/controllers/auth_controller.dart';

final GameLobbyApi gameLobbyApi = GameLobbyApi();
final logger = Logger();

class GameActivityListController extends GetxController {
  var isLoading = false.obs;
  var activityList = <ActivityItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    Get.find<AuthController>().token.listen((event) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      var res = await gameLobbyApi.getActivityList();
      activityList.value = res;
    } catch (error) {
      logger.i('fetchData GameActivityListController: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
