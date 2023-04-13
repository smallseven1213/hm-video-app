import 'banner_photo.dart';

class ChannelBanner {
  final List<BannerPhoto> channelBanners;
  final List<BannerPhoto> areaBanners;
  final List<BannerPhoto>? areaAdsHorizontal;
  final List<BannerPhoto>? areaAdsVertical;

  ChannelBanner(
    this.channelBanners,
    this.areaBanners, {
    this.areaAdsHorizontal,
    this.areaAdsVertical,
  });

  factory ChannelBanner.fromJson(Map<String, dynamic> json) {
    return ChannelBanner(
      List.from(json['channel'] as List<dynamic>)
          .map((e) => BannerPhoto.fromJson(e))
          .toList(),
      List.from(json['area'] as List<dynamic>)
          .map((e) => BannerPhoto.fromJson(e))
          .toList(),
      areaAdsHorizontal: List.from(json['areaAdsHorizontal'] as List<dynamic>)
          .map((e) => BannerPhoto.fromJson(e))
          .toList(),
      areaAdsVertical: List.from(json['areaAdsVertical'] as List<dynamic>)
          .map((e) => BannerPhoto.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channelBanners.map((e) => e.toJson()).toList(),
      'area': areaBanners.map((e) => e.toJson()).toList(),
      'areaAdsHorizontal': areaAdsHorizontal?.map((e) => e.toJson()).toList(),
      'areaAdsVertical': areaAdsVertical?.map((e) => e.toJson()).toList(),
    };
  }
}
