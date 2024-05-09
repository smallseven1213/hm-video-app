import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:shared/controllers/auth_controller.dart';

class GameBannerController extends GetxController {
  var isLoading = false.obs;
  var gameMarquee = [].obs;
  var gameBanner = [].obs;
  var customerServiceUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGameBanners();
    Get.find<AuthController>().token.listen((event) {
      fetchGameBanners();
    });
  }

  Future<void> fetchGameBanners() async {
    isLoading.value = true;
    try {
      var res = await Get.put(GameLobbyApi()).getMarqueeAndBanner();
      gameBanner.value = res['banner'];
      gameMarquee.value = res['marquee'];
      customerServiceUrl.value =
          res['customerServiceUrl'] ? res['customerServiceUrl'][0]['url'] : '';
    } catch (error) {
      logger.i('fetchGameBanners error: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
