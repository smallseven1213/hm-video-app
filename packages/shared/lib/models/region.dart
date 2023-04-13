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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['orderIndex'] = this.orderIndex;
    return data;
  }
}
