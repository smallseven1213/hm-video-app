import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_user_detail.dart';

final LiveApi liveApi = LiveApi();

class LiveUserController extends GetxController {
  var userDetail = Rxn<LiveUserDetail>();
  var isAutoRenew = false.obs;

  double get getAmount => userDetail.value?.wallet ?? 0;

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
  }

  void getUserDetail() async {
    var getUserDetails = await liveApi.getUserDetail();
    userDetail.value = getUserDetails.data;
  }

  void setAutoRenew(bool value) {
    isAutoRenew.value = value;
  }
}
