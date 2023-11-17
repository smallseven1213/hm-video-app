import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/system_config_controller.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class AreaApi {
  static final AreaApi _instance = AreaApi._internal();

  AreaApi._internal();

  factory AreaApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<List<Vod>> getPopular(int areaId, int videoId) async {
    var res = await fetcher(
        url:
            '$apiHost/public/areas/area/shortVideo/popular?areaId=$areaId&videoId=$videoId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
  }
}
