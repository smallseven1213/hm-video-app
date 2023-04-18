import 'package:get/get.dart';

class Video {
  int id;
  String title;
  int? film;
  int? chargeType; // 付費類型：1 免費, 2 金幣, 3 VIP
  String? points;
  String? coverVertical;
  String? coverHorizontal;
  String? videoUrl;
  bool? isPreview;
  bool? isCollected;
  String? externalId;
  String? buyPoints = "0";
  int? timeLength;
  bool isPlay = false;
  bool started = false;
  bool hideAD = false;

  Video({
    required this.id,
    required this.title,
    this.film,
    this.chargeType,
    this.points,
    this.buyPoints,
    this.isCollected,
    this.externalId,
    this.videoUrl,
    this.isPreview,
    this.coverHorizontal,
    this.coverVertical,
    this.timeLength,
  });

  Video.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        title = json['title'],
        film = json['film'],
        chargeType = json['chargeType'],
        points = json['points'],
        buyPoints = json['buyPoints'],
        isCollected = json['isCollected'],
        externalId = json['externalId'],
        videoUrl = json['videoUrl'],
        isPreview = json['isPreview'],
        coverHorizontal = json['coverHorizontal'],
        coverVertical = json['coverVertical'],
        timeLength = json['timeLength'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['film'] = film;
    data['chargeType'] = chargeType;
    data['points'] = points;
    data['buyPoints'] = buyPoints;
    data['isCollected'] = isCollected;
    data['externalId'] = externalId;
    data['videoUrl'] = videoUrl;
    data['isPreview'] = isPreview;
    data['coverHorizontal'] = coverHorizontal;
    data['coverVertical'] = coverVertical;
    data['timeLength'] = timeLength;
    return data;
  }
}
