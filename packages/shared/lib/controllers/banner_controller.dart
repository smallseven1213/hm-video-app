import 'package:get/get.dart';
import 'package:shared/apis/banner_api.dart';

class BannerController extends GetxController {
  final _banners = {}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  get banners => _banners.value;

  void setBanners(id) {
    banners[id] = id;
  }

  Future<void> fetchBanner() async {
    print('loading game states');
    BannerApi bannerApi = BannerApi();
    final BannerController bannerController = Get.put(BannerController());
    var res = await bannerApi.getBannerById(positionId: '8');
    bannerController.setBanners(res);
  }
}
