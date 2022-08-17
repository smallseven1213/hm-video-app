import 'package:get/get.dart';
import 'package:wgp_video_h5app/models/jingangs.dart';

class VJingangController extends GetxController {
  List<JinGang> jingangs = [];
  Map<int, JinGang> getJingang() {
    return jingangs.asMap();
    // return {
    //   0: JinGang(1, '遊戲', '5cf347ab-8271-46fb-bc3b-475a2b96a6a3'),
    //   1: JinGang(2, 'VIP', '7fbb3214-ccc6-46a4-bd62-294924957648'),
    //   2: JinGang(3, '演員', '5cf347ab-8271-46fb-bc3b-475a2b96a6a3'),
    //   3: JinGang(4, '直播', '5cf347ab-8271-46fb-bc3b-475a2b96a6a3'),
    //   4: JinGang(5, '遊戲', '5cf347ab-8271-46fb-bc3b-475a2b96a6a3'),
    // };
  }

  void setJingangs(List<JinGang> _jingangs) {
    jingangs = _jingangs;
    update();
  }
}
