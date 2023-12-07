import 'package:get/get.dart';

class LiveSystemController extends GetxController {
  var liveApiHost = ''.obs;

  String get liveApiHostValue => liveApiHost.value;
}
