import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/privilege_api.dart';
import '../models/user_privilege_record.dart';

final PrivilegeApi privilegeApi = PrivilegeApi();
final logger = Logger();

class UserPrivilegeController extends GetxController {
  var privilegeRecord = <UserPrivilegeRecord>[].obs;

  UserPrivilegeController({required String userId}) {
    _fetchData(userId);
    Get.find<AuthController>().token.listen((event) {
      _fetchData(userId);
    });
  }

  _fetchData(userId) async {
    var res = await privilegeApi.getManyBy(userId: userId);
    privilegeRecord.value = res;
  }
}
