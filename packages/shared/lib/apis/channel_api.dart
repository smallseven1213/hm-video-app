import '../models/banner_photo.dart';
import '../models/channel_info.dart';
import '../models/channel_shared_data.dart';
import '../models/jingang.dart';
import '../models/slim_channel.dart';
import '../models/tag.dart';
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

  // Get channel/v2/channelInfo?channelId=54
  Future<ChannelSharedData> getOneById(int channelId) async {
    var res = await fetcher(
        url: '$apiPrefix/channel/v2/channelInfo?channelId=$channelId');
    if (res.data['code'] != '00') {
      return ChannelSharedData();
    }
    ChannelSharedData channelSharedData = ChannelSharedData(
        banner: List.from((res.data['data']['banner'] as List<dynamic>)
            .map((e) => BannerPhoto.fromJson(e))),
        jingang: Jingang.fromJson(res.data['data']['jingang']),
        tags: Tags.fromJson(res.data['data']['tags']),
        blocks: List.from((res.data['data']['blocks'] as List<dynamic>)
            .map((e) => Blocks.fromJson(e))));

    return channelSharedData;
  }
}
