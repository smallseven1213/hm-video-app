import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/banner_photo.dart';
import '../utils/fetcher.dart';
import '../models/index.dart';

class NoticeApi {
  static final NoticeApi _instance = NoticeApi._internal();

  NoticeApi._internal();

  factory NoticeApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/notices';

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

  // 彈窗公告
  Future<Map?> getBounce() async =>
      await fetcher(url: '$apiHost/api/v1/banner/bounce-data').then((res) {
        if (res.data['code'] != '00') {
          return null;
        }
        if (res.data['data'] != null) {
          return {
            'notice': Notice.fromJson(res.data['data']['notice']),
            'banners': res.data['data']['banners'].map<BannerPhoto>((v) {
              return BannerPhoto.fromJson(v);
            }).toList()
          };
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
