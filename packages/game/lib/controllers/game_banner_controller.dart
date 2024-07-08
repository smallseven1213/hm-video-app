import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameBannerController extends GetxController {
  var isLoading = false.obs;
  var gameMarquee = [].obs;
  var gameBanner = [].obs;
  var customerServiceUrl = ''.obs;

  Future<void> fetchGameBanners() async {
    isLoading.value = true;
    try {
      var res = await Get.put(GameLobbyApi()).getMarqueeAndBanner();
      gameBanner.value = res['banner'];
      gameMarquee.value = res['marquee'];
      customerServiceUrl.value = res['customerServiceUrl'].length > 0
          ? res['customerServiceUrl'][0]['url']
          : '';
    } catch (error) {
      logger.i('fetchGameBanners error: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
