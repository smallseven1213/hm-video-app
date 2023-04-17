import 'package:shared/models/vod.dart';

class InfinityVod {
  final List<Vod> vods;
  final int totalCount;
  final bool hasMoreData;

  InfinityVod(this.vods, this.totalCount, this.hasMoreData);
}
