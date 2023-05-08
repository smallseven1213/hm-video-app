import 'package:shared/models/tag.dart';

import 'banner_image.dart';
import 'jingang.dart';

class ChannelInfo {
  List<BannerImage>? banner;
  Jingang? jingang;
  List<Blocks>? blocks;

  ChannelInfo({banner, jingang, blocks});

  ChannelInfo.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <BannerImage>[];
      json['banner'].forEach((v) {
        banner!.add(BannerImage.fromJson(v));
      });
    }
    jingang =
        json['jingang'] != null ? Jingang.fromJson(json['jingang']) : null;
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(Blocks.fromJson(v));
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
  bool? isAreaAds;
  bool? isTitle;
  bool? isLoading;
  bool? isEmbeddedAds;
  BannerImage? banner;
  Videos? videos;

  Blocks(
      {id,
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
      videos});

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
        json['banner'] != null ? BannerImage.fromJson(json['banner']) : null;
    videos = json['videos'] != null ? Videos.fromJson(json['videos']) : null;
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
  num? total;
  String? current;
  num? limit;
  List<Data>? data;

  Videos({total, current, limit, data});

  Videos.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    current = json['current'];
    limit = json['limit'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['current'] = current;
    data['limit'] = limit;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Data {
  int? id;
  int? dataType;
  String? title;
  String? titleSub;
  String? externalId;
  int? chargeType;
  int? points;
  int? subScript;
  int? timeLength;
  String? coverVertical;
  String? coverHorizontal;
  List<Tag>? tags;
  int? videoViewTimes;
  int? videoCollectTimes;
  String? appIcon;
  String? adUrl;

  Data(
      {id,
      dataType,
      title,
      titleSub,
      externalId,
      chargeType,
      points,
      subScript,
      timeLength,
      coverVertical,
      coverHorizontal,
      tags,
      videoViewTimes,
      videoCollectTimes,
      appIcon,
      adUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataType = json['dataType'];
    title = json['title'];
    titleSub = json['titleSub'];
    externalId = json['externalId'];
    chargeType = json['chargeType'];
    points = json['points'];
    subScript = json['subScript'];
    timeLength = json['timeLength'];
    coverVertical = json['coverVertical'];
    coverHorizontal = json['coverHorizontal'];
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    videoViewTimes = json['videoViewTimes'];
    videoCollectTimes = json['videoCollectTimes'];
    appIcon = json['appIcon'];
    adUrl = json['adUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dataType'] = dataType;
    data['title'] = title;
    data['titleSub'] = titleSub;
    data['externalId'] = externalId;
    data['chargeType'] = chargeType;
    data['points'] = points;
    data['subScript'] = subScript;
    data['timeLength'] = timeLength;
    data['coverVertical'] = coverVertical;
    data['coverHorizontal'] = coverHorizontal;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['videoViewTimes'] = videoViewTimes;
    data['videoCollectTimes'] = videoCollectTimes;
    data['appIcon'] = appIcon;
    data['adUrl'] = adUrl;
    return data;
  }
}
