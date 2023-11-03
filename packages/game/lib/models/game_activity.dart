import 'dart:convert';
import 'package:flutter/material.dart';

class ActivityItem {
  ActivityItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.imgUrl,
    required this.type,
    required this.content,
    required this.buttonStyle,
    this.buttonName,
  });

  final int id;
  final String title;
  final String subTitle;
  final String imgUrl;
  final int type;
  final String content;
  final int buttonStyle;
  final String? buttonName;

  factory ActivityItem.fromRawJson(String str) =>
      ActivityItem.fromJson(json.decode(str));

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
        id: json["id"],
        title: json["title"],
        subTitle: json["subTitle"],
        imgUrl: json["imgUrl"],
        type: json["type"],
        content: json["content"],
        buttonStyle: json["buttonStyle"],
        buttonName: json["buttonName"],
      );
}

Map<int, Map<String, dynamic>> activityTypeMapper = {
  1: {
    'name': '首充活動',
    'color': const Color(0xFFff039e),
  },
  2: {
    'name': '充值活動',
    'color': const Color(0xFF03ff0d),
  },
  3: {
    'name': '投注活動',
    'color': const Color(0xFFff6d03),
  },
};

Map<String, int> activityButtonType = {
  'NONE': 1,
  'CS': 2,
  'SUBMIT_CAMPAIGN': 3,
};

Map<int, String> activityResStatus = {
  0: '未充值',
  1: '已申請',
  2: '審核中',
  3: '已發放',
  4: '申請失敗',
};

Map<String, int> activityButtonStatus = {'ENABLE': 0};
