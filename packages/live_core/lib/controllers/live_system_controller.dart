import 'package:get/get.dart';

class LiveSystemController extends GetxController {
  var liveApiHost = ''.obs;
  var liveWsHost = ''.obs;

  String get liveApiHostValue => liveApiHost.value;
  String get liveWsHostValue => liveWsHost.value;
}
