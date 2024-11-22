import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/system_config_controller.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class ImageApi {
  static final ImageApi _instance = ImageApi._internal();

  ImageApi._internal();

  factory ImageApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get imgHost => _systemConfigController.imgHost.value!;

  Future<String?> getSidImageData(String sid) async {
    try {
      var res = await fetcher(url: '$imgHost/images/$sid');
      var result = res.data;
      return result;
    } catch (e) {
      // throw err
      logger.i('err: get sid image');
    }
    return null;
  }
}
