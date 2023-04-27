import 'package:get/get.dart';

class ApiResponseErrorCatchController extends GetxController {
  final responseStatus = 0.obs;
  final responseMessage = ''.obs;

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
}
