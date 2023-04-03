import 'package:shared/services/system_config.dart';
import '../utils/fetcher.dart';
import '../models/index.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/notices';

class NoticeApi {
  // 消息中心的公告
  Future<Notice?> getNoticeAnnouncement(int page, int limit) async =>
      await fetcher(
              url: '$apiPrefix/notice/announcement?page=$page&limit=$limit')
          .then((res) {
        if (res.data['code'] != '00') {
          return null;
        }
        if (res.data['data'] != null) {
          return Notice.fromJson(res.data['data']);
        }
        return null;
      });

  // 彈窗公告
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

  // 跑馬燈
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
