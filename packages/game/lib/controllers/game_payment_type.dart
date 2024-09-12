import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/models/game_deposit_payments_type.dart';
import 'package:shared/controllers/auth_controller.dart';

final GameLobbyApi gameLobbyApi = GameLobbyApi();
final logger = Logger();

class DepositPaymentsTypeController extends GetxController {
  var isLoading = false.obs;
  var paymentTypeList = <DepositPaymentsType>[].obs;
  var isSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepositPaymentsType();
    Get.find<AuthController>().token.listen((event) {
      fetchDepositPaymentsType();
    });
  }

  Future<void> fetchDepositPaymentsType() async {
    try {
      isLoading.value = true;
      var res = await gameLobbyApi.getPaymentsType();
      if (res.isEmpty) {
        isSuccess.value = false;
      } else {
        paymentTypeList.value = res;
        isSuccess.value = true;
      }
    } catch (error) {
      logger.i('fetchDepositPaymentsType error: $error');
      isSuccess.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
