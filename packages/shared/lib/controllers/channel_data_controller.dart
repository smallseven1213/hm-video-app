// ChannelScreenTabController用來儲存目前tabIndex與pageViewIndex的狀態
// 並且在tabbar或pageView的index發生改變時，更新兩者的index

import 'package:get/get.dart';

import '../apis/vod_api.dart';
import '../models/block.dart';

class ChannelDataController extends GetxController {
  var channelData = <int, List<Block>>{}.obs;

  void mutateByChannelId(int channelId) async {
    var res = await VodApi().getBlockVodsByChannelAds(channelId);
    print('resres $res');
    channelData[channelId] = res;
  }
}
