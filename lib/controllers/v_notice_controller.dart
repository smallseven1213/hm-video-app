import 'package:get/get.dart';
import 'package:wgp_video_h5app/models/notices.dart';

class VNoticeController extends GetxController {
  List<Notice> marquee = [];

  Map<int, Notice> getMarquee() {
    return marquee.asMap();
  }

  void setMarquee(List<Notice> value) {
    marquee = value;
    update();
  }
}
