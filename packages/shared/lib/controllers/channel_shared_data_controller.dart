import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/channel_api.dart';
import '../models/channel_shared_data.dart';

var logger = Logger();
final channelApi = ChannelApi();

class ChannelSharedDataController extends GetxController {
  final int channelId;
  var channelSharedData = Rx<ChannelSharedData?>(null);
  var isLoading = false.obs;

  ChannelSharedDataController({required this.channelId}) {
    mutateByChannelId(channelId);
  }

  void mutateByChannelId(int channelId) async {
    isLoading.value = true;
    var res = await channelApi.getOneById(channelId);
    logger.i(res);
    channelSharedData.value = res;
    isLoading.value = false;
  }
}
