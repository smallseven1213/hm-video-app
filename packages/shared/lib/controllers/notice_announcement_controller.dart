import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/notice_api.dart';
import '../models/notices.dart';

final logger = Logger();

class NoticeAnnouncementController extends GetxController {
  final _announcement = <Notice>[].obs;
  final _hasMore = true.obs;
  final _isLoading = false.obs;
  final _page = 1.obs;
  final _limit = 100.obs;
  final _isInit = false.obs;

  List<Notice> get announcement => _announcement;
  bool get hasMore => _hasMore.value;
  bool get isLoading => _isLoading.value;
  int get page => _page.value;
  int get limit => _limit.value;
  bool get isInit => _isInit.value;

  @override
  void onInit() {
    super.onInit();
    _fetchMoreAnnouncement();
  }

  Future<void> _fetchMoreAnnouncement() async {
    if (_isLoading.value) {
      return;
    }
    _isLoading.value = true;
    final res = await NoticeApi().getNoticeAnnouncement(
      _page.value,
      _limit.value,
    );
    logger.i(res);
    if (res.isNotEmpty) {
      _announcement.addAll(res);
      _page.value++;
    }
    _isLoading.value = false;
  }

  Future<void> refreshData() async {
    _announcement.clear();
    _page.value = 1;
    _fetchMoreAnnouncement();
  }
}
