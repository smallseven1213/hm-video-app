import 'dart:async';
import 'package:get/get.dart';
import 'package:shared/apis/banner_api.dart';

import '../models/banner_photo.dart';
import '../models/index.dart';

class BannerData {
  final BannerPosition positionId;
  final List<BannerPhoto> bannerList;

  BannerData(this.positionId, this.bannerList);
}

class BannerController extends GetxController {
  RxMap<BannerPosition, List<BannerPhoto>> banners =
      <BannerPosition, List<BannerPhoto>>{}.obs;

  void setBanners(BannerPosition positionId, List<BannerPhoto> bannerList) {
    banners[positionId] = bannerList;
    update();
  }

  Future<List<BannerPhoto>> fetchBanner(BannerPosition position) async {
    BannerApi bannerApi = BannerApi();
    final BannerController bannerController = Get.find<BannerController>();
    // 進站廣告5秒超時
    if (position == BannerPosition.landing) {
      try {
        var result = await bannerApi
            .getBannerById(positionId: position.value) // 修改这里
            .timeout(const Duration(seconds: 5), onTimeout: () {
          throw TimeoutException("Request timeout after 5 seconds");
        });
        bannerController.setBanners(position, result); // 修改这里
        return result;
      } on TimeoutException catch (e) {
        print(e.message);
        return [];
      } catch (e) {
        print(e);
        return [];
      }
    } else {
      var result =
          await bannerApi.getBannerById(positionId: position.value); // 修改这里
      bannerController.setBanners(position, result); // 修改这里
      return result;
    }
  }

  // 檢查是否有banner by position id
  bool hasBanner(BannerPosition position) {
    return banners[position.value] != null &&
        banners[position.value]!.isNotEmpty;
  }

  // 紀錄點擊banner
  Future<void> recordBannerClick(int bannerId) async {
    if (bannerId == 0) return;
    BannerApi bannerApi = BannerApi();
    await bannerApi.recordBannerClick(bannerId: bannerId);
  }
}
