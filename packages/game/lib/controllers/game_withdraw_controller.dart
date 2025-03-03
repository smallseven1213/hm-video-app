import 'package:game/apis/game_api.dart';
import 'package:game/models/user_withdrawal_data.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameWithdrawController extends GetxController {
  RxDouble points = 0.00.obs;
  var paymentPin = false.obs;
  var loadingStatus = true.obs;
  var enableSubmit = true.obs;
  var paymentAmount = '0.00'.obs;

  // <!--- userPaymentSecurity{} --->
  var userPaymentSecurity = [].obs;
  var hasBankPaymentData = false.obs;
  var hasUsdtPaymentData = false.obs;
  var bankIsBound = false.obs;
  var usdtIsBound = false.obs;
  var initRemittanceType = 1.obs;

  // <!--- userKyc{} --->
  var userKyc = [].obs;
  var cellPhoneIsBound = false.obs;
  var idCardIsBound = false.obs;
  var idCardStatus = Rx<int?>(null);

  getWithDrawalData() async {
    try {
      var res = await GameLobbyApi().getUserGameWithdrawalData();

      if (res['code'] != '00') {
        return res;
      } else {
        paymentPin.value = res['data'].paymentPin ?? false;
        points.value = res['data'].points ?? 0.00;
        userPaymentSecurity.value = res['data'].userPaymentSecurity;
        userKyc.value = res['data'].userKyc;
        initRemittanceType.value =
            res['data'].userPaymentSecurity.first.remittanceType;

        // <!--- userPaymentSecurity{} --->
        for (UserPaymentSecurity paymentSecurity
            in res['data'].userPaymentSecurity) {
          if (paymentSecurity.remittanceType == remittanceTypeEnum['USDT']) {
            usdtIsBound.value = paymentSecurity.isBound;
            hasUsdtPaymentData.value = true;
          } else {
            // paymentSecurity底下remittanceType不等於USDT的項目中，只要有一個isBound為false，就不會顯示銀行卡選項
            if (paymentSecurity.remittanceType != remittanceTypeEnum['USDT'] &&
                paymentSecurity.isBound == false) {
              hasBankPaymentData.value = false;
            } else {
              bankIsBound.value = paymentSecurity.isBound;
              hasBankPaymentData.value = true;
            }
          }
        }

        for (UserKyc kycData in res['data'].userKyc) {
          if (kycData.kycType == kycTypeEnum['CELL_PHONE']) {
            cellPhoneIsBound.value = kycData.isBound;
          } else if (kycData.kycType == kycTypeEnum['ID_CARD']) {
            idCardIsBound.value = kycData.isBound;
            idCardStatus.value = kycData.status;
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
