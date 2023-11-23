import 'package:shared/models/banner_photo.dart';

class BannerParamConfig {
  final List<int> config;

  BannerParamConfig({required this.config});

  factory BannerParamConfig.fromJson(Map<String, dynamic> json) {
    return BannerParamConfig(
      config: List<int>.from(json['config'].map((x) => x)),
    );
  }
}

class ShortVideoAds {
  final List<BannerPhoto>? appDownloadAds; // 下方banner廣告
  final List<BannerPhoto>? shortPlayingAds; // 播放中廣告
  final BannerParamConfig bannerParamConfig; // 播放中廣告參數設定

  ShortVideoAds({
    this.appDownloadAds,
    this.shortPlayingAds,
    required this.bannerParamConfig,
  });

  factory ShortVideoAds.fromJson(Map<String, dynamic> json) {
    return ShortVideoAds(
      appDownloadAds: (json['appDownloadAds'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      shortPlayingAds: (json['shortPlayingAds'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      bannerParamConfig: BannerParamConfig.fromJson(json['bannerParamConfig']),
    );
  }
}
