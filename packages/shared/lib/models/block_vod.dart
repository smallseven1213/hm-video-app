import 'package:shared/models/vod.dart';

class BlockVod {
  final List<Vod> vods;
  final int total;
  final num limit;

  BlockVod(
    this.vods,
    this.total, {
    this.limit = 10,
  });

  // fromJson
  BlockVod.fromJson(Map<String, dynamic> json)
      : vods = (json['vods'] as List)
            .map((e) => Vod.fromJson(e as Map<String, dynamic>))
            .toList(),
        total = json['total'] as int,
        limit = json['limit'] as num;

  // toJson
  Map<String, dynamic> toJson() => {
        'vods': vods.map((e) => e.toJson()).toList(),
        'total': total,
        'limit': limit,
      };
}
