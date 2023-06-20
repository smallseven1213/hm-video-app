// v2的簡易版channel data model
class SlimChannel {
  final int id;
  final String name;
  final int style;
  final bool isSearch;

  SlimChannel(this.id, this.name, this.style, this.isSearch);

  factory SlimChannel.fromJson(Map<String, dynamic> json) {
    return SlimChannel(
      json['id'],
      json['name'],
      json['style'],
      json['isSearch'],
    );
  }
}
