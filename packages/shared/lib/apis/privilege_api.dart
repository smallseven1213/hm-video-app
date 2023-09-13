import 'package:shared/models/user_privilege_record.dart';
import 'package:shared/services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/privileges';

class PrivilegeApi {
  static final PrivilegeApi _instance = PrivilegeApi._internal();

  PrivilegeApi._internal();

  factory PrivilegeApi() {
    return _instance;
  }

  Future<List<UserPrivilegeRecord>> getManyBy({
    required String userId,
    int page = 1,
    int limit = 100,
  }) async {
    var res = await fetcher(
        url:
            '$apiPrefix/privilege/list/userId?page=$page&limit=$limit&userId=$userId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => UserPrivilegeRecord.fromJson(e)));
  }
}
