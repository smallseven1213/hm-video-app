import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final GameLobbyApi gameLobbyApi = GameLobbyApi();
final logger = Logger();

class GameParamConfigController extends GetxController {
  var isLoading = false.obs;
  var appDownload = ''.obs;
  var activityEntrance = ''.obs;

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
