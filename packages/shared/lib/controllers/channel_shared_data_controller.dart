import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/channel_api.dart';
import '../models/channel_shared_data.dart';

var logger = Logger();
final channelApi = ChannelApi();

class ChannelSharedDataController extends GetxController {
  final int channelId;
  var channelSharedData = Rx<ChannelSharedData?>(null);

  ChannelSharedDataController({required this.channelId}) {
    mutateByChannelId(channelId);
  }

  void mutateByChannelId(int channelId) async {
    var res = channelApi.getOneById(channelId);
    // channelData.value = res;
  }
}
