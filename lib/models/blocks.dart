import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class Block {
  final int id;
  final String name;
  final int template;
  final int? quantity;
  final int? orderIndex;
  final bool? isMore;
  final bool? isChange;
  final bool? isTitle;
  final bool? isAreaAds;
  final BlockVod? videos;

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
      isAreaAds: json['isAreaAds'],
      videos: json['videos'] == null
          ? BlockVod([], 0)
          : BlockVod(
              List.from((json['videos']['data'] as List<dynamic>)
                  .map((e) => Vod.fromJson(e))),
              json['videos']['total']),
    );
  }
}
