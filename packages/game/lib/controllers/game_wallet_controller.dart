import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';

class GameWalletController extends GetxController {
  var wallet = 0.00.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("WalletState init");
  }

  void fetchWallets() async {
    isLoading.value = true;
    try {
      var res = await GameLobbyApi().getPoints();
      wallet.value = double.parse(res['balance'] ?? '0');
    } catch (error) {
      print('_fetchWallets: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void mutate() {
    fetchWallets();
  }
}
