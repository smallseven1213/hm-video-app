import 'jingang.dart';

class Channel {
  final int id;
  final String name;
  final int? layout;
  final int? style;
  final bool? isBanner;
  final List<int>? jingang;
  final int jingangStyle;
  final List<JinGang>? jingangDetail;
  final bool? outerFrame;
  final int outerFrameStyle;
  final String? title;
  final int quantity;

  Channel(
    this.id,
    this.name, {
    this.layout,
    this.style,
    this.isBanner,
    this.jingang,
    this.jingangStyle = 1,
    this.jingangDetail,
    this.outerFrame,
    this.outerFrameStyle = 1,
    this.title,
    this.quantity = 4,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      json['id'],
      json['name'],
      jingang: json['jingang'] == null ? [] : List.from(json['jingang']),
      jingangStyle: json['jingangStyle'] ?? 1, // 1: 單排, 2: 雙排
      jingangDetail: json['jingangDetail'] == null
          ? []
          : List.from((json['jingangDetail'] as List<dynamic>)
              .map((e) => JinGang.fromJson(e))),
      isBanner: json['isBanner'] ?? false,
      outerFrame: json['outerFrame'] ?? false, // 是否有外框
      outerFrameStyle: json['outerFrameStyle'] ?? 1, // 1: 圓形, 2: 方形
      quantity: json['quantity'] ?? 4, // 一排的數量，預設: 4
      title: json['title'] ?? '',
    );
  }
}
