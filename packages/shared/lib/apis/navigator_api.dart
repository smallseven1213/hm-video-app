// NavigatorApi, has GET'navigations/navigation' by fetcher function

import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/navigation.dart';
import '../utils/fetcher.dart';

class NavigatorApi {
  static final NavigatorApi _instance = NavigatorApi._internal();

  NavigatorApi._internal();

  factory NavigatorApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<List<Navigation>> getNavigations(int type) async {
    try {
      var res = await fetcher(
          url: '$apiHost/public/navigations/navigation?type=$type');
      if (res.data['code'] != '00') {
        return [];
      }
      return List.from((res.data['data'] as List<dynamic>)
          .map((e) => Navigation.fromJson(e)));
    } catch (e) {
      return [];
    }
  }
}
