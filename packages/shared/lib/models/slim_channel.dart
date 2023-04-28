// v2的簡易版channel data model
class SlimChannel {
  final int id;
  final String name;
  final int style;

  SlimChannel(this.id, this.name, this.style);

  factory SlimChannel.fromJson(Map<String, dynamic> json) {
    return SlimChannel(
      json['id'],
      json['name'],
      json['style'],
    );
  }
}
