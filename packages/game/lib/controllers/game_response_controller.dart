import 'package:get/get.dart';

class GameApiResponseErrorCatchController extends GetxController {
  final responseStatus = 0.obs;
  final responseMessage = ''.obs;
  final RxBool alertDialogShown = false.obs;

  // @override
  // void onInit() async {
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void emitEvent(int status, String message) {
    responseStatus.value = status;
    responseMessage.value = message;
  }

  void setAlertDialogShown(bool shown) {
    alertDialogShown.value = shown;
  }

  // 清除狀態
  void clear() {
    emitEvent(0, '');
    alertDialogShown.value = false;
  }
}
