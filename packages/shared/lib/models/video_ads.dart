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

class VideoAds {
  final List<BannerPhoto>? bottomPositions; // 下方banner廣告
  final List<BannerPhoto>? playerPositions; // 播放前banner廣告
  final List<BannerPhoto>? appDownloadAds; // app下載廣告
  final List<BannerPhoto>? playingAds; // 播放中廣告
  final List<BannerPhoto>? stopAds; // 播放暫停banner廣告
  final BannerParamConfig bannerParamConfig; // 播放中廣告參數設定

  VideoAds({
    this.bottomPositions,
    this.playerPositions,
    this.appDownloadAds,
    this.playingAds,
    this.stopAds,
    required this.bannerParamConfig,
  });

  factory VideoAds.fromJson(Map<String, dynamic> json) {
    return VideoAds(
      bottomPositions: (json['bottomPositions'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      playerPositions: (json['playerPositions'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      appDownloadAds: (json['appDownloadAds'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      playingAds: (json['playingAds'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      stopAds: (json['stopAds'] as List)
          .map((e) => BannerPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      bannerParamConfig: BannerParamConfig.fromJson(json['bannerParamConfig']),
    );
  }
}
