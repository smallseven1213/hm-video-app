class Navigation {
  int? id;
  String? name;
  String? photoSid;
  String? clickEffect;
  String? path;
  int? type;

  Navigation({id, name, photoSid, clickEffect, path, type});

  Navigation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoSid = json['photoSid'];
    clickEffect = json['clickEffect'];
    path = json['path'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photoSid'] = photoSid;
    data['clickEffect'] = clickEffect;
    data['path'] = path;
    data['type'] = type;
    return data;
  }
}
