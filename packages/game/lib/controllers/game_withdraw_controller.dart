import 'package:game/models/user_withdrawal_data.dart';
import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameWithdrawController extends GetxController {
  RxDouble points = 0.00.obs;
  var userPaymentSecurity = [].obs;
  var paymentPin = false.obs;
  var loadingStatus = true.obs;
  var enableSubmit = true.obs;
  var paymentAmount = '0.00'.obs;

  // <!--- userPaymentSecurity{} --->
  var hasBankPaymentData = false.obs;
  var hasUsdtPaymentData = false.obs;
  var bankIsBound = false.obs;
  var usdtIsBound = false.obs;

  getWithDrawalData() async {
    int remittanceTypeCny = remittanceTypeMapper['BANK_CARD_CNY'] ?? 1;
    int remittanceTypeUsdt = remittanceTypeMapper['USDT'] ?? 2;

    try {
      var res = await GameLobbyApi().getUserGameWithdrawalData();

      if (res['code'] != '00') {
        return res;
      } else {
        paymentPin.value = res['data'].paymentPin ?? false;
        points.value = res['data'].points ?? 0.00;
        userPaymentSecurity.value = res['data'].userPaymentSecurity;

        // <!--- userPaymentSecurity{} --->
        for (UserPaymentSecurity paymentSecurity
            in res['data'].userPaymentSecurity) {
          if (paymentSecurity.remittanceType == remittanceTypeCny) {
            bankIsBound.value = paymentSecurity.isBound;
            hasBankPaymentData.value = true;
          } else if (paymentSecurity.remittanceType == remittanceTypeUsdt) {
            usdtIsBound.value = paymentSecurity.isBound;
            hasUsdtPaymentData.value = true;
          }
        }

        return res;
      }
    } catch (e) {
      logger.i('GameWithdrawController error: $e');
    }
  }

  void setWithDrawalDataNotEmpty() {
    hasBankPaymentData.value = true;
  }

  void setLoadingStatus(bool status) {
    loadingStatus.value = status;
  }

  void setSubmitButtonDisable(bool status) {
    enableSubmit.value = status;
  }

  void setDepositAmount(String amount) {
    paymentAmount.value = amount;
  }

  void mutate() {
    getWithDrawalData();
  }
}
