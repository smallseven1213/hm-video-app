// v2的簡易版channel data model
class SlimChannel {
  final int id;
  final String name;
  final int style;
  final bool isSearch;
  final bool isDefault;

  SlimChannel(this.id, this.name, this.style, this.isSearch, this.isDefault);

  factory SlimChannel.fromJson(Map<String, dynamic> json) {
    return SlimChannel(
      json['id'],
      json['name'],
      json['style'],
      json['isSearch'],
      json['isDefault'],
    );
  }
}
