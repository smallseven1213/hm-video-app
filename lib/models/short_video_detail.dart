import 'package:video_player/video_player.dart';
import 'package:wgp_video_h5app/models/supplier.dart';
import 'package:wgp_video_h5app/models/videos_tag.dart';

import '../controllers/app_controller.dart';

class ShortVideoDetail {
  final int id;
  final List<VideoTag> tag;
  final Supplier? supplier;

  ShortVideoDetail(this.id, this.tag, this.supplier);

  factory ShortVideoDetail.fromJson(Map<String, dynamic> json) {
    return ShortVideoDetail(
      json['id'],
      List.from((json['tag']as List<dynamic>).map((e) => VideoTag.fromJson(e))),
        json['supplier'] !=null ? Supplier.fromJson(json['supplier']) : null,
    );
  }
}
