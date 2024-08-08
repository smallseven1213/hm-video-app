import 'dart:convert';

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

Map<String, int> activityButtonType = {
  'NONE': 1,
  'CS': 2,
  'SUBMIT_CAMPAIGN': 3,
};

Map<String, int> activityButtonStatus = {'ENABLE': 0};
