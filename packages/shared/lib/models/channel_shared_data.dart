// 金剛區共用Class

import 'package:shared/models/banner_photo.dart';
import 'channel_info.dart';
import 'jingang.dart';
import 'tag.dart';

class ChannelSharedData {
  List<BannerPhoto>? banner;
  Jingang? jingang;
  List<Tag>? tags;
  List<Blocks>? blocks;

  ChannelSharedData({this.banner, this.jingang, this.tags, this.blocks});

  ChannelSharedData.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <BannerPhoto>[];
      json['banner'].forEach((v) {
        banner!.add(BannerPhoto.fromJson(v));
      });
    }
    jingang =
        json['jingang'] != null ? Jingang.fromJson(json['jingang']) : null;
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(Blocks.fromJson(v));
      });
    }
  }
}
