import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/vod_api.dart';
import '../models/channel_info.dart';

var logger = Logger();

class ChannelDataController extends GetxController {
  final int channelId;
  int offset = 1;
  var channelData = Rx<ChannelInfo?>(null);
  var isError = false.obs;

  ChannelDataController({required this.channelId}) {
    mutateByChannelId(channelId);
  }

  void mutateByChannelId(int channelId) async {
    try {
      isError.value = false;
      var res =
          await VodApi().getBlockVodsByChannelAds(channelId, offset: offset);
      channelData.value = res;
      logger.i(res);
    } catch (e) {
      isError.value = true;
    } finally {}
  }
}
