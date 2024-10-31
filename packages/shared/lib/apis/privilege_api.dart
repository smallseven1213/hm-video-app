import 'package:get/get.dart';
import 'package:shared/models/user_privilege_record.dart';
import '../controllers/system_config_controller.dart';
import '../utils/fetcher.dart';

class PrivilegeApi {
  static final PrivilegeApi _instance = PrivilegeApi._internal();

  PrivilegeApi._internal();

  factory PrivilegeApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/api/v1/user/privileges';

  Future<List<UserPrivilegeRecord>> getManyBy({
    required String userId,
    int page = 1,
    int limit = 100,
  }) async {
    var res = await fetcher(
        url: '$apiPrefix?page=$page&limit=$limit&userId=$userId',
        timezone: '+8');
    if (res.data['code'] != '00') {
      return [];
    }
    // mock data
    // return List.from(([
    //   {
    //     'previousExpiredAt': '2021-08-31T07:00:00.000Z',
    //     'typeName': 'VIP',
    //     'remark': 'VIP',
    //     'expiredAt': '2021-09-30T07:00:00.000Z',
    //   },
    //   {
    //     'previousExpiredAt': '2023-08-31T07:00:00.000Z',
    //     'typeName': 'VIP2',
    //     'remark': 'VIP2',
    //     'expiredAt': '2023-09-30T07:00:00.000Z',
    //   },
    //   {
    //     'previousExpiredAt': '2023-08-31T07:00:00.000Z',
    //     'typeName': 'VIP3',
    //     'remark': 'VIP3',
    //     'expiredAt': '2023-09-30T07:00:00.000Z',
    //   },
    //   {
    //     'previousExpiredAt': '2021-08-31T07:00:00.000Z',
    //     'typeName': 'VIP4',
    //     'remark': 'VIP4',
    //     'expiredAt': '2021-09-01T07:00:00.000Z',
    //   },
    // ] as List<dynamic>)
    return List.from((res.data['data'] as List<dynamic>)
        .map((e) => UserPrivilegeRecord.fromJson(e)));
  }
}
