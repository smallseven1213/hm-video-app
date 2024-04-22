import 'package:shared/models/game.dart';
import 'package:shared/models/vod.dart';

import 'banner_photo.dart';
import 'jingang.dart';

class ChannelInfo {
  List<BannerPhoto>? banner;
  Jingang? jingang;
  List<Blocks>? blocks;

  ChannelInfo({banner, jingang, blocks});

  ChannelInfo.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <BannerPhoto>[];
      json['banner'].forEach((v) {
        banner!.add(BannerPhoto.fromJson(v));
      });
    }
    jingang =
        json['jingang'] != null ? Jingang.fromJson(json['jingang']) : null;
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        if (v['blockType'] != null && v['blockType'] == 1) {
          blocks!.add(Blocks.fromJson(v));
          return;
        } else if (v['blockType'] == 2) {
          // blocks!.add(Game.fromJson(v));
        } else {
          blocks!.add(Blocks.fromJson(v));
          return;
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    if (jingang != null) {
      data['jingang'] = jingang!.toJson();
    }
    if (blocks != null) {
      data['blocks'] = blocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blocks {
  int? id;
  String? name;
  int? template; // block 1 ~ 6
  int? film; // 1: 長視頻 2: 短視頻 3: 漫畫
  int? quantity;
  int? orderIndex;
  bool? isMore;
  bool? isCheckMore;
  bool? isChange;
  bool? isAreaAds; // 暫時沒用
  bool? isTitle;
  bool? isLoading;
  bool? isEmbeddedAds;
  BannerPhoto? banner;
  Videos? videos;
  int? blockType;

  Blocks({
    id,
    name,
    template,
    film,
    quantity,
    orderIndex,
    isMore,
    isCheckMore,
    isChange,
    isAreaAds,
    isTitle,
    isLoading,
    isEmbeddedAds,
    banner,
    videos,
    blockType,
  });

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    template = json['template'];
    film = json['film'];
    quantity = json['quantity'];
    orderIndex = json['orderIndex'];
    isMore = json['isMore'];
    isCheckMore = json['isCheckMore'];
    isChange = json['isChange'];
    isAreaAds = json['isAreaAds'];
    isTitle = json['isTitle'];
    isLoading = json['isLoading'];
    isEmbeddedAds = json['isEmbeddedAds'];
    banner =
        json['banner'] != null ? BannerPhoto.fromJson(json['banner']) : null;
    videos = json['videos'] != null ? Videos.fromJson(json['videos']) : null;
    blockType = json['blockType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['template'] = template;
    data['film'] = film;
    data['quantity'] = quantity;
    data['orderIndex'] = orderIndex;
    data['isMore'] = isMore;
    data['isCheckMore'] = isCheckMore;
    data['isChange'] = isChange;
    data['isAreaAds'] = isAreaAds;
    data['isTitle'] = isTitle;
    data['isLoading'] = isLoading;
    data['isEmbeddedAds'] = isEmbeddedAds;
    data['blockType'] = blockType;
    if (banner != null) {
      data['banner'] = banner!.toJson();
    }
    if (videos != null) {
      data['videos'] = videos!.toJson();
    }
    return data;
  }
}

class Videos {
  int? total;
  int? current;
  int? limit;
  List<Vod>? data;

  Videos({this.total, this.current, this.limit, this.data});

  Videos.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    current = json['current'];
    limit = json['limit'];
    if (json['data'] != null) {
      data = <Vod>[];
      json['data'].forEach((v) {
        data!.add(Vod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['current'] = current;
    data['limit'] = limit;
    if (this.data != null && this.data!.isNotEmpty) {
      data['data'] = this.data!.map((Vod v) {
        try {
          return v.toJson();
        } catch (e) {
          return Vod(0, '');
        }
      }).toList();
    }
    return data;
  }
}
