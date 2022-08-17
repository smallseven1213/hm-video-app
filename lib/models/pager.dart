import 'package:wgp_video_h5app/models/index.dart';

class Pager<T> {
  final int total;
  final String current;
  final String limit;
  final List<T> data;

  Pager({
        required this.total,
        required this.current,
        required this.limit,
        required this.data,
      });

  factory Pager.fromJson(Map<String, dynamic> json, List<T> data) {
    return Pager(
      total : json['total'],
      current :json['current'],
      limit : json['limit'],
      data: data
    );
  }
}
