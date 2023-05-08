// 金剛區共用Class

import 'package:shared/models/banner_photo.dart';
import 'banner_image.dart';
import 'channel_info.dart';
import 'jingang.dart';
import 'tag.dart';

class ChannelSharedData {
  List<BannerImage>? banner;
  Jingang? jingang;
  List<Tag>? tags;
  List<Blocks>? blocks;

  ChannelSharedData({banner});
}
