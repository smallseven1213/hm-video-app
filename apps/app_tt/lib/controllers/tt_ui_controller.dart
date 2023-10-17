import 'package:get/get.dart';
import 'package:logger/logger.dart';


var logger = Logger();

class TTUIController extends GetxController {
  final RxBool isDarkMode = false.obs;


  TTUIController();

  void setDarkMode(bool value) {
    isDarkMode.value = value;
  }
}
