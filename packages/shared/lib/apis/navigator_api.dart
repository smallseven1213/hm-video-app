// NavigatorApi, has GET'navigations/navigation' by fetcher function

import '../models/navigation.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();

class NavigatorApi {
  Future<List<Navigation>> getNavigations() async {
    try {
      var res = await fetcher(
          url: '${systemConfig.apiHost}/public/navigations/navigation');
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
