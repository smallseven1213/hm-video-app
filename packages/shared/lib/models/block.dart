import 'package:shared/models/vod.dart';

import 'ad_item.dart';
import 'block_vod.dart';

class Block {
  final int id;
  final String name;
  final int template;
  final int? quantity;
  final int? orderIndex;
  final bool? isMore;
  final bool? isChange;
  final bool? isTitle;
  final bool isAreaAds;
  final bool isEmbeddedAds;
  final bool? isCheckMore;
  final BlockVod? videos;
  final AdItem? areaAds;

  Block(
    this.id,
    this.name,
    this.template, {
    this.quantity = 0,
    this.orderIndex = 0,
    this.isMore = false,
    this.isChange = false,
    this.isTitle = true,
    this.isAreaAds = false,
    this.isCheckMore = false,
    this.isEmbeddedAds = false,
    this.areaAds,
    this.videos,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      json['id'],
      json['name'],
      json['template'],
      quantity: json['quantity'],
      orderIndex: json['orderIndex'],
      isMore: json['isMore'],
      isChange: json['isChange'],
      isTitle: json['isTitle'],
      isAreaAds: json['isAreaAds'] ?? false,
      isCheckMore: json['isCheckMore'],
      isEmbeddedAds: json['isEmbeddedAds'] ?? false,
      areaAds: json['areaAds'] == null
          ? AdItem('', url: '', id: 0)
          : AdItem(
              json['areaAds']['photoSid'] ?? '',
              url: json['areaAds']['url'] ?? '',
              id: json['areaAds']['id'] as int,
            ),
      videos: json['videos'] == null
          ? BlockVod([], 0)
          : BlockVod(
              List.from((json['videos']['data'] as List<dynamic>)
                  .map((e) => Vod.fromJson(e))),
              json['videos']['total'],
              limit: json['videos']['limit'],
            ),
    );
  }
}
