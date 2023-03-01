import '../models/channel.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/channels';

class ChannelApi {
  Future<List<Channel>> getManyByLayout(int layoutId) async {
    var res = await fetcher(url: '$apiPrefix/channel/list?layout=$layoutId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Channel.fromJson(e)));
  }
}
