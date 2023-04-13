import 'package:logger/logger.dart';

import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class ImageApi {
  Future<String> getSidImageData(String sid) async {
    var res = await fetcher(url: '${systemConfig.imgHost}/images/$sid');
    var result = res.data;
    return result;
  }
}
