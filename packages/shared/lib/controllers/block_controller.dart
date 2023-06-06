// create a block controller
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import '../models/channel_info.dart';

class BlockController extends GetxController {
  final block = Blocks().obs;

  mutateBybBlockId(int id, int offset) async {
    // call api, by block id
    var res = await VodApi().getBlockVodsByBlockId(id, offset: offset);
    logger.i('res: $res');
    return res;
  }
}
