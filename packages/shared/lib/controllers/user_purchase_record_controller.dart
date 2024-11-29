import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/points_api.dart';
import '../models/user_purchase_record.dart';

final PointApi pointApi = PointApi();
final logger = Logger();

class UserPurchaseRecordController extends GetxController {
  var pointRecord = <UserPurchaseRecord>[].obs;

  void initCollection({required String userId}) {
    _fetchData(userId);
    Get.find<AuthController>().token.listen((event) {
      _fetchData(userId);
    });
  }

  _fetchData(userId) async {
    var res = await pointApi.getPoints();
    pointRecord.value = res;
  }
}
