import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_auth_controller.dart';

class GameBannerController extends GetxController {
  var isLoading = false.obs;
  var gameMarquee = [].obs;
  var gameBanner = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGameBanners();
    Get.find<GameAuthController>().token.listen((event) {
      fetchGameBanners();
    });
  }

  Future<void> fetchGameBanners() async {
    isLoading.value = true;
    try {
      var res = await GameLobbyApi().getMarqueeAndBanner();

      gameBanner = res['banner'];
      gameMarquee = res['marquee'];
    } catch (error) {
      print('fetchGameBanners: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
