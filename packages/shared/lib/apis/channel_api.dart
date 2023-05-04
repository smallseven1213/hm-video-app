import '../models/slim_channel.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/channels';

class ChannelApi {
  static final ChannelApi _instance = ChannelApi._internal();

  ChannelApi._internal();

  factory ChannelApi() {
    return _instance;
  }

  Future<List<SlimChannel>> getManyByLayout(int layoutId) async {
    var res = await fetcher(url: '$apiPrefix/channel/v2/list?layout=$layoutId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['channel'] as List<dynamic>)
        .map((e) => SlimChannel.fromJson(e)));
  }
}
