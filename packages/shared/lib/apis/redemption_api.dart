import 'package:shared/models/redemption.dart';
import 'package:shared/services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/redemption/redemption';

class RedemptionApi {
  static final RedemptionApi _instance = RedemptionApi._internal();

  RedemptionApi._internal();

  factory RedemptionApi() {
    return _instance;
  }

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
