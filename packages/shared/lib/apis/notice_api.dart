import 'package:shared/services/system_config.dart';
import '../utils/fetcher.dart';
import '../models/index.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/notices';

class NoticeApi {
  Future<Notice?> getMany() async =>
      await fetcher(url: '$apiPrefix/notice/announcement').then((res) {
        if (res.data['code'] != '00') {
          return null;
        }
        if (res.data['data'] != null) {
          return Notice.fromJson(res.data['data']);
        }
        return null;
      });

  Future<Notice?> getBounceOne() async =>
      await fetcher(url: '$apiPrefix/notice/latest/bounce').then((res) {
        if (res.data['code'] != '00') {
          return null;
        }
        if (res.data['data'] != null) {
          return Notice.fromJson(res.data['data']);
        }
        return null;
      });

  Future<Notice?> getMarquee() async =>
      await fetcher(url: '$apiPrefix/notice/latest/marquee').then((res) {
        if (res.data['code'] != '00') {
          return null;
        }
        if (res.data['data'] != null) {
          return Notice.fromJson(res.data['data']);
        }
        return null;
      });
}
