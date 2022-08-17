class BannerPhoto {
  final int id;
  final String photoSid;
  final String? url;
  final bool isAutoClose;

  BannerPhoto(
    this.id,
    this.photoSid,
    this.url, {
    this.isAutoClose = false,
  });
  factory BannerPhoto.fromJson(Map<String, dynamic> json) {
    return BannerPhoto(
      json['id'],
      json['photoSid'],
      json['url'],
      isAutoClose: json['isAutoClose'] ?? false,
    );
  }
}

class BlockBanners {
  final int blockId;
  final List<BannerPhoto> banners;

  BlockBanners(this.blockId, this.banners);
  factory BlockBanners.fromJson(Map<String, dynamic> json) {
    return BlockBanners(
        json['areaId'],
        List.from(json['banner'] as List<dynamic>)
            .map((e) => BannerPhoto(e['id'], e['photoSid'], e['url']))
            .toList());
  }
}

class ChannelBanner {
  final List<BannerPhoto> channelBanners;
  final Map<int, BlockBanners> blockBanners;

  ChannelBanner(this.channelBanners, this.blockBanners);
  factory ChannelBanner.fromJson(Map<String, dynamic> json) {
    return ChannelBanner(
        List.from(json['channel'] as List<dynamic>)
            .map((e) => BannerPhoto(e['id'], e['photoSid'], e['url']))
            .toList(),
        List.from(json['area'] as List<dynamic>).asMap().map((key, value) =>
            MapEntry(value['areaId'], BlockBanners.fromJson(value))));
  }
}
