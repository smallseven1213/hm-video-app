import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/vod_api.dart';
import '../models/channel_info.dart';

var logger = Logger();

class ChannelDataController extends GetxController {
  var channelData = <int, ChannelInfo>{}.obs;

  void mutateByChannelId(int channelId) async {
    var res = await VodApi().getBlockVodsByChannelAds(channelId);
    channelData[channelId] = res;
  }
}
