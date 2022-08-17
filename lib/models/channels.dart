class Channel {
  final int id;
  final String name;
  final int? layout;
  final int? style;
  final bool? isBanner;
  final List<int>? jingang;
  final int jingangStyle;
  final bool? outerFrame;
  final String? title;

  Channel(
    this.id,
    this.name, {
    this.layout,
    this.style,
    this.isBanner,
    this.jingang,
    this.jingangStyle = 1,
    this.outerFrame,
    this.title,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      json['id'],
      json['name'],
      jingang: json['jingang'] == null ? [] : List.from(json['jingang']),
      jingangStyle: json['jingangStyle'] ?? 1,
      isBanner: json['isBanner'] ?? false,
      outerFrame: json['outerFrame'] ?? false,
      title: json['title'] ?? '',
    );
  }
}
