import 'package:shared/helpers/get_field.dart';

class Supplier {
  int? id;
  String? aliasName;
  String? name;
  int? shortVideoTotal;
  int? followTotal;
  int? collectTotal;
  String? photoSid;
  String? coverVertical;
  String? description;
  int? videoCount;

  Supplier({
    this.id,
    this.aliasName,
    this.name,
    this.shortVideoTotal,
    this.followTotal,
    this.collectTotal,
    this.photoSid,
    this.coverVertical,
    this.description,
    this.videoCount,
  });

  Supplier.fromJson(Map<String, dynamic> json) {
    id = getField(json, 'id', defaultValue: 0);
    aliasName = getField(json, 'aliasName', defaultValue: '');
    name = getField(json, 'name', defaultValue: '');
    shortVideoTotal = getField(json, 'shortVideoTotal', defaultValue: 0);
    followTotal = getField(json, 'followTotal', defaultValue: 0);
    collectTotal = getField(json, 'collectTotal', defaultValue: 0);
    photoSid = getField(json, 'photoSid', defaultValue: '');
    coverVertical = getField(json, 'coverVertical', defaultValue: '');
    description = getField(json, 'description', defaultValue: '');
    videoCount = getField(json, 'videoCount', defaultValue: 0);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['aliasName'] = aliasName;
    data['name'] = name;
    data['shortVideoTotal'] = shortVideoTotal;
    data['followTotal'] = followTotal;
    data['collectTotal'] = collectTotal;
    data['photoSid'] = photoSid;
    data['coverVertical'] = coverVertical;
    data['description'] = description;
    data['videoCount'] = videoCount;
    return data;
  }
}
