import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import '../controllers/auth_controller.dart';
import '../controllers/response_controller.dart';

// create a dio instance
final logger = Logger();
final dio = Dio();

/// url: 網址
/// method: 請求方法
/// headers: 請求標頭
/// body: 請求內容
/// shouldValidate: 是否需要驗證
// Future<Response> fetcher({
Future<dynamic> fetcher({
  required String url,
  String? method = 'GET',
  Map<String, dynamic>? headers = const {},
  Map<String, dynamic>? body = const {},
  FormData? form,
  bool? shouldValidate = true,
}) async {
  // create a request options
  // Map? authorization = shouldValidate!
  //     ? null
  //     : {'authorization': 'Bearer ${systemConfig.authToken}'};
  final responseController = getx.Get.find<ApiResponseErrorCatchController>();

  final token = getx.Get.find<AuthController>().token;
  AuthController authController = getx.Get.find<AuthController>();

  final headerConfig = {
    'accept-language': 'zh-TW,zh;q=0.9,en;q=0.8,zh-CN;q=0.7,zh-HK;q=0.6',
    'authorization': 'Bearer $token',
  };

  final options = Options(
    method: method,
    headers: {
      ...headerConfig,
    },
    contentType: Headers.jsonContentType,
  );

  Object? data;
  if (body != null && body.isNotEmpty) {
    data = {
      ...body,
    };
  }

  try {
    // dio.addSentry();
    final response = await dio.request(
      url,
      data: form ?? data,
      options: options,
    );

    return response;
  } on DioException catch (e) {
    if (e.response?.statusCode == 401 && e.response?.data['code'] == '04') {
      // 清除 GetStorage 中的 auth-token
      final storage = GetStorage();
      storage.remove('auth-token');
      authController.setToken('');
      responseController.emitEvent(401, 'Unauthorized');
    } else {
      // 其他錯誤處理
      responseController.emitEvent(e.response?.statusCode ?? 0, 'Other error');
      return e.response;
    }
    rethrow;
  }
  // logger.d('in testing fetcher : $url\n======\n$response');
}
