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
    id = json['id'];
    aliasName = json['aliasName'];
    name = json['name'];
    shortVideoTotal = json['shortVideoTotal'];
    followTotal = json['followTotal'];
    collectTotal = json['collectTotal'];
    photoSid = json['photoSid'];
    coverVertical = json['coverVertical'];
    description = json['description'];
    videoCount = json['videoCount'];
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
