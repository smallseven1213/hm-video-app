import 'block_vod.dart';

class AreaInfoWithBlockVod {
  int id;
  String name;
  int template;
  int film;
  BlockVod? videos;

  AreaInfoWithBlockVod(
      {required this.id,
      required this.name,
      required this.template,
      required this.film,
      this.videos});

  factory AreaInfoWithBlockVod.fromJson(Map<String, dynamic> json) {
    return AreaInfoWithBlockVod(
        id: json['id'] as int,
        name: json['name'] as String,
        template: json['template'] as int,
        film: json['film'] as int,
        videos:
            json['videos'] != null ? BlockVod.fromJson(json['videos']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['template'] = template;
    data['film'] = film;
    if (videos != null) {
      data['videos'] = videos!.toJson();
    }
    return data;
  }
}
