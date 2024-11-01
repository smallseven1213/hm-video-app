import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/privilege_api.dart';
import '../models/user_privilege_record.dart';

final PrivilegeApi privilegeApi = PrivilegeApi();
final logger = Logger();

class UserPrivilegeController extends GetxController {
  var privilegeRecord = <UserPrivilegeRecord>[].obs;

  fetchData() async {
    var res = await privilegeApi.getManyBy();
    privilegeRecord.value = res;
  }
}
