import 'package:shared/services/system_config.dart';
import '../utils/fetcher.dart';
import '../models/index.dart';

final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/notices';

class NoticeApi {
  static final NoticeApi _instance = NoticeApi._internal();

  NoticeApi._internal();

  factory NoticeApi() {
    return _instance;
  }

  // 消息中心的公告
  Future<List<Notice>> getNoticeAnnouncement(int page, int limit) async {
    var res = await fetcher(
        url: '$apiPrefix/notice/announcement?page=$page&limit=$limit');
    if (res.data['code'] != '00') {
      return [];
    }
    if (res.data['data']['data'] != null) {
      return res.data['data']['data'].map<Notice>((v) {
        return Notice.fromJson(v);
      }).toList();
    }
    return [];
  }

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
