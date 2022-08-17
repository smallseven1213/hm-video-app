class Region {
  final int id;
  final String name;
  final int? orderIndex;
  final bool? enabled;

  Region(this.id, this.name, {this.orderIndex, this.enabled = true});
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      json['id'],
      json['name'],
      orderIndex: json['orderIndex'],
      enabled: json['enabled'],
    );
  }
}
