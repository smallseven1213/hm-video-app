import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';

class GameWithdrawController extends GetxController {
  RxDouble points = 0.00.obs;
  var paymentPin = false.obs;
  var userPaymentSecurity = [].obs;
  var hasPaymentData = false.obs;
  var loadingStatus = true.obs;
  var enableSubmit = true.obs;

  getWithDrawalData() async {
    try {
      var res = await GameLobbyApi().getUserGameWithdrawalData();

      if (res['code'] != '00') {
        return res;
      } else {
        userPaymentSecurity.value = res['data'].userPaymentSecurity ?? [];
        hasPaymentData.value =
            res['data'].userPaymentSecurity!.isNotEmpty ? true : false;
        points.value = res['data'].points ?? 0.00;
        paymentPin.value = res['data'].paymentPin ?? false;

        return res;
      }
    } catch (e) {
      print('GameWithdrawController error: $e');
    }
  }

  void setWithDrawalDataNotEmpty() {
    hasPaymentData.value = true;
  }

  void setLoadingStatus(bool status) {
    loadingStatus.value = status;
  }

  void setSubmitButtonDisable(bool status) {
    enableSubmit.value = status;
  }

  void mutate() {
    getWithDrawalData();
  }
}
