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
    required this.buttonName,
  });

  final int id;
  final String title;
  final String subTitle;
  final String imgUrl;
  final int type;
  final String content;
  final int buttonStyle;
  final String buttonName;

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

Map<int, String> activityButtonType = {
  1: 'NONE',
  2: 'CS',
  3: 'SUBMIT_CAMPAIGN',
};
