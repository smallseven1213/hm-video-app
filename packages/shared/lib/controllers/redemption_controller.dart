import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/redemption.dart';
import '../apis/redemption_api.dart';

final RedemptionApi redemptionApi = RedemptionApi();
final logger = Logger();

class RedemptionController extends GetxController {
  var records = <Redemption>[].obs;

  RedemptionController() {
    fetchData();
  }

  fetchData() async {
    var res = await redemptionApi.records();
    records.value = res;
  }

  Future<String> redeem(String serialNumberId) async {
    var res = await redemptionApi.redeem(serialNumberId);
    return res;
  }
}
