import 'package:get/get.dart';
import 'package:shared/apis/game_api.dart';
import 'package:shared/controllers/auth_controller.dart';

class GameBannerController extends GetxController {
  var isLoading = false.obs;
  var gameMarquee = [].obs;
  var gameBanner = [].obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<AuthController>().token.listen((event) {
      fetchGameBanners();
    });
    update();
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
