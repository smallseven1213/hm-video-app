import 'jingang_detail.dart';

class Jingang {
  List<JinGangDetail>? jingangDetail;
  bool? outerFrame;
  int? outerFrameStyle;
  String? title;
  int? jingangStyle;
  int? quantity;

  Jingang({
    jingangDetail,
    outerFrame, // 是否有外框
    outerFrameStyle, // 1: 圓形, 2: 方形
    title, // 金剛區標題
    jingangStyle, // 1: 單排, 2: 多排
    quantity, // 一排的數量，預設: 4
  });

  Jingang.fromJson(Map<String, dynamic> json) {
    if (json['jingangDetail'] != null) {
      jingangDetail = <JinGangDetail>[];
      json['jingangDetail'].forEach((v) {
        jingangDetail!.add(JinGangDetail.fromJson(v));
      });
    }
    outerFrame = json['outerFrame'];
    outerFrameStyle = json['outerFrameStyle'];
    title = json['title'];
    jingangStyle = json['jingangStyle'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (jingangDetail != null) {
      data['jingangDetail'] = jingangDetail!.map((v) => v.toJson()).toList();
    }
    data['outerFrame'] = outerFrame;
    data['outerFrameStyle'] = outerFrameStyle;
    data['title'] = title;
    data['jingangStyle'] = jingangStyle;
    data['quantity'] = quantity;
    return data;
  }
}
