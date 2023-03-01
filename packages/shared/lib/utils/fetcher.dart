import 'package:dio/dio.dart';
import 'package:shared/services/system_config.dart';

// create a dio instance
final dio = Dio();
final SystemConfig systemConfig = SystemConfig();

/// url: 網址
/// method: 請求方法
/// headers: 請求標頭
/// body: 請求內容
/// shouldValidate: 是否需要驗證
Future<Response> fetcher({
  required String url,
  String? method = 'GET',
  Map<String, dynamic>? headers = const {},
  Map<String, dynamic>? body = const {},
  bool? shouldValidate = true,
}) async {
  // create a request options
  Map? authorization = shouldValidate!
      ? null
      : {'authorization': 'Bearer ${systemConfig.authToken}'};

  final options = Options(
    method: method,
    headers: {
      'accept-language': 'zh-TW,zh;q=0.9,en;q=0.8,zh-CN;q=0.7,zh-HK;q=0.6',
      'content-type': 'application/json; charset=utf-8',
      'authorization': 'Bearer ${systemConfig.authToken}',
    },
  );

  final response = await dio.request(
    url,
    data: body,
    options: options,
  );

  return response;
}
