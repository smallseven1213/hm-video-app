// getx TagPopularController, has List<Tag> obs
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/supplier_api.dart';
import '../models/video.dart';

class VideoShortBySupplierController extends GetxController {
  var data = <Video>[].obs;
  int supplierId = 0;
  int videoId = 0;

  VideoShortBySupplierController(this.supplierId, this.videoId);

  @override
  void onInit() async {
    super.onInit();
    fetchData(supplierId, videoId);
    Get.find<AuthController>().token.listen((event) {
      fetchData(supplierId, videoId);
    });
  }

  Future<void> fetchData(tagId, videoId) async {
    SupplierApi supplierApi = SupplierApi();
    var result =
        await supplierApi.getPlayList(supplierId: tagId, videoId: videoId);
    data.value = result;
  }
}
