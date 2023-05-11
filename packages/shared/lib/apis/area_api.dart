import 'package:logger/logger.dart';
import '../models/video.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class AreaApi {
  static final AreaApi _instance = AreaApi._internal();

  AreaApi._internal();

  factory AreaApi() {
    return _instance;
  }

  Future<List<Video>> getPopular(int areaId, int videoId) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/areas/area/shortVideo/popular?areaId=$areaId&videoId=$videoId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Video.fromJson(e)));
  }
}
