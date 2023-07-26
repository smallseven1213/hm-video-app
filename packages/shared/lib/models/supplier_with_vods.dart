import 'actor.dart';
import 'vod.dart';

class SupplierForVods {
  int containVideos;
  String coverVertical;
  int followTimes;
  int id;
  String name;
  String photoSid;
  String? description;

  SupplierForVods({
    required this.containVideos,
    required this.coverVertical,
    required this.followTimes,
    required this.id,
    required this.name,
    required this.photoSid,
    this.description,
  });

  // fromJson method
  factory SupplierForVods.fromJson(Map<String, dynamic> json) {
    return SupplierForVods(
      containVideos: json['containVideos'],
      coverVertical: json['coverVertical'],
      followTimes: json['followTimes'],
      id: json['id'],
      name: json['name'],
      photoSid: json['photoSid'],
      description: json['description'],
    );
  }
}

class SupplierWithVod {
  SupplierForVods supplier;
  List<Vod> vods;

  SupplierWithVod(this.supplier, this.vods);
}
