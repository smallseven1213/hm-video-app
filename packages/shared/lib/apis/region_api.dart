import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/system_config_controller.dart';
import '../models/region.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class RegionApi {
  static final RegionApi _instance = RegionApi._internal();

  RegionApi._internal();

  factory RegionApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<List<Region>> getActorRegions() async {
    var res =
        await fetcher(url: '$apiHost/api/v1/region/has-actor?page=1&limit=100');
    if (res.data['code'] != '00') {
      return [];
    }

    List<Region> regions = res.data['data']['data']
        .map<Region>((item) => Region.fromJson(item))
        .toList();
    return regions;
  }

  Future<List<Region>> getRegions(int film) async {
    var res =
        await fetcher(url: '$apiHost/api/v1/region?page=1&limit=10&film=$film');
    if (res.data['code'] != '00') {
      return [];
    }

    List<Region> regions = res.data['data']['data']
        .map<Region>((item) => Region.fromJson(item))
        .toList();
    return regions;
  }
}
