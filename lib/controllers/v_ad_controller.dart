import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/models/banners.dart';
import 'package:wgp_video_h5app/providers/ad_provider.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class VAdController extends GetxController {
  Map<int, List<BannerPhoto>> positionBanners = {};
  Map<int, BannerPhoto> positionBanner = {};
  Map<int, ImageProvider> positionBannerImage = {};

  Future<void> addPositionBanners(int positionId) async {
    var ads = await Get.find<AdProvider>().getBannersByPosition(positionId);
    if (ads.isNotEmpty) {
      positionBanners[positionId] = List.of(ads);
      ads.shuffle();
      positionBanner[positionId] = ads.first;
      var imageProvider = Get.find<ImagesProvider>();
      var image = await imageProvider.getImage(ads.first.photoSid);
      if (image != null) {
        positionBannerImage[positionId] = image.image;
      }
    } else {
      positionBanners[positionId] = [];
      await Future.delayed(const Duration(seconds: 1));
    }
    update();
  }
}
