import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:game/services/game_system_config.dart';
import 'package:game/controllers/game_response_controller.dart';
import 'package:shared/controllers/auth_controller.dart';

// create a dio instance
final logger = Logger();
final dio = Dio();
final GameSystemConfig systemConfig = GameSystemConfig();

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
  bool? shouldValidate = true,
}) async {
  final responseController = Get.find<GameApiResponseErrorCatchController>();

  final token = Get.find<AuthController>().token;
  AuthController authController = Get.find<AuthController>();

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
    final response = await dio.request(
      url,
      data: data,
      options: options,
    );

    return response;
  } on DioError catch (e) {
    print('errror: e.response?.statusCode: ${e.response?.statusCode}');
    if (e.response?.statusCode == 401) {
      // 清除 GetStorage 中的 auth-token
      final storage = GetStorage();
      storage.remove('auth-token');
      authController.setToken('');
      responseController.emitEvent(401, 'Unauthorized');
    } else {
      // 其他錯誤處理
      responseController.emitEvent(e.response?.statusCode ?? 0, 'Other error');
    }
    rethrow;
  }
  // logger.d('in testing fetcher : $url\n======\n$response');
}
