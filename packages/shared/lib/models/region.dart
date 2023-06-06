class Region {
  int? id;
  String? name;
  int? orderIndex;

  Region({this.id, this.name, this.orderIndex});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    orderIndex = json['orderIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['orderIndex'] = orderIndex;
    return data;
  }
}
