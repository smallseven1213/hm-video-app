import '../models/channel.dart';
import '../utils/fetcher.dart';

class ChannelApi {
  Future<List<Channel>> getManyByLayout(int layoutId) async {
    var res = await fetcher(url: '/channel/list?layout=$layoutId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Channel.fromJson(e)));
  }
}
