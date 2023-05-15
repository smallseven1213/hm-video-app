import 'package:get/get.dart';

class ApiResponse {
  ApiResponse({required this.status, required this.message});

  final int status;
  final String message;
}

class ApiResponseErrorCatchController extends GetxController {
  final Rx<ApiResponse> apiResponse =
      Rx<ApiResponse>(ApiResponse(status: 0, message: ''));

  final RxBool alertDialogShown = false.obs;

  void emitEvent(int status, String message) {
    apiResponse.value = ApiResponse(status: status, message: message);
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
