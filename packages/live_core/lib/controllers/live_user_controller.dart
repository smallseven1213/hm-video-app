import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_user_detail.dart';

final LiveApi liveApi = LiveApi();

class LiveUserController extends GetxController {
  var userDetail = Rxn<LiveUserDetail>();

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
  }

  void getUserDetail() async {
    // Call the API to get user details
    var getUserDetails = await liveApi.getUserDetail();
    userDetail.value = getUserDetails.data;
  }
}
