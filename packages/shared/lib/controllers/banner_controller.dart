import 'package:get/get.dart';
import 'package:shared/apis/banner_api.dart';

import '../models/index.dart';

class BannerController extends GetxController {
  final banners = {}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setBanners(int positionId, List bannerList) {
    banners[positionId] = bannerList;
    update();
  }

  Future<List> fetchBanner(BannerPosition position) async {
    BannerApi bannerApi = BannerApi();
    final BannerController bannerController = Get.put(BannerController());
    var result = await bannerApi.getBannerById(positionId: position.index);
    bannerController.setBanners(position.index, result);
    return result;
  }
}
