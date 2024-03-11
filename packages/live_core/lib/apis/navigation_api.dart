import 'package:shared/controllers/system_config_controller.dart';
import 'package:get/get.dart';

import '../controllers/live_system_controller.dart';
import '../models/navigation.dart';
import '../utils/live_fetcher.dart';

class NavigationApi {
  static final NavigationApi _instance = NavigationApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();
  LiveSystemController liveSystemController = Get.find<LiveSystemController>();

  NavigationApi._internal();

  factory NavigationApi() {
    return _instance;
  }

  Future<List<Navigation>> getNavigation() async {
    var userApiHost = liveSystemController.liveApiHost.value;
    var response = await liveFetcher(
      url: '$userApiHost/user/v1/navigation',
    );

    List<Navigation> ads = (response.data['data'] as List)
        .map((item) => Navigation.fromJson(item))
        .toList();

    return ads;
  }
}
