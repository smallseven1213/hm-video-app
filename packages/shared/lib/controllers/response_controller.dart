import 'package:get/get.dart';

class ResponseController extends GetxController {
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

  void updateResponseStatus(int status) {
    responseStatus.value = status;
  }

  void updateResponseMessage(String message) {
    responseMessage.value = message;
  }
}
