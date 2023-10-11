import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_api.dart';

final GameLobbyApi gameLobbyApi = GameLobbyApi();
final logger = Logger();

class GameParamConfigController extends GetxController {
  var isLoading = false.obs;
  var appDownload = ''.obs;
  var activityEntrance = ''.obs;

  @override
  void onReady() {
    super.onReady();
    fetchData();
    // Get.find<AuthController>().token.listen((event) {
    //   fetchData();
    // });
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      var res = await gameLobbyApi.getGameParamConfig();
      if (res.data != null) {
        appDownload.value = res.data!.appDownload!;
        activityEntrance.value = res.data!.activityEntrance!;
      }
    } catch (error) {
      logger.i('fetchData GameParamConfigController: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
