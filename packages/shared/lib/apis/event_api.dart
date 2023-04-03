import 'package:logger/logger.dart';

import '../models/ad.dart';
import '../models/channel_banner.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final logger = Logger();
final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/events';

class EventApi {
  Future<dynamic> getEvents() async {
    var res = await fetcher(url: '${systemConfig.apiHost}/event/latest');
    if (res.data['code'] != '00') {
      return ChannelBanner(
        [],
        [],
      );
    }
    return ChannelBanner.fromJson(res.data['data']);
  }

  void deleteEvents(List<int> ids) async {
    var res = await fetcher(
        url: '${systemConfig.apiHost}/event/id=${ids.join(',')}',
        method: 'delete');
  }
}
