import 'package:dio/dio.dart';

// create a dio instance
final dio = Dio();

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
  bool? shouldValidate = false,
}) async {
  // create a request options
  final options = Options(
    method: method,
    headers: headers,
  );

  // make a request
  final response = await dio.request(
    url,
    data: body,
    options: options,
  );

  return response;
}
