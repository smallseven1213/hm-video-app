import 'package:get/get.dart';
import 'package:shared/models/redemption.dart';
import '../controllers/system_config_controller.dart';
import '../utils/fetcher.dart';

class RedemptionApi {
  static final RedemptionApi _instance = RedemptionApi._internal();

  RedemptionApi._internal();

  factory RedemptionApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/redemption/redemption';

  Future<List<Redemption>> records() async {
    var res = await fetcher(url: '$apiPrefix/records');
    if (res.data['code'] != '00' || res.data['data'].isEmpty) {
      return [];
    }
    return List.from(
      (res.data['data'] as List<dynamic>).map((e) => Redemption.fromJson(e)),
    );
  }

  Future<String> redeem(String serialNumberId) async {
    var value = await fetcher(
        url: '$apiPrefix/redeem',
        method: 'POST',
        body: {'serialNumberId': serialNumberId});

    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return res['message'];
    }
    return "兌換成功";
  }
}
