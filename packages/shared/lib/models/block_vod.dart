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
}
