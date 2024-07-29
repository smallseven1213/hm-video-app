import 'package:shared/models/supplier.dart';
import 'package:shared/models/tag.dart';

class Post {
  final int id; // 貼文 ID
  final String title; // 貼文標題
  final Supplier? supplier; // UP主資訊
  final int chargeType; // 收費模式：1=免費, 2=金幣, 3=VIP
  final bool isUnlock; // 當前用戶是否解鎖：true=用戶解鎖或免費貼文
  final int previewMediaCount; // 可預覽附件數量
  final int totalMediaCount; // 總附件數量
  final List<Files> files; // 附件陣列
  final List<Tag> tags; // 附件陣列

  Post(
    this.id,
    this.title,
    this.supplier,
    this.chargeType,
    this.isUnlock,
    this.previewMediaCount,
    this.totalMediaCount,
    List<Files>? files,
    List<Tag>? tags,
  )   : files = files ?? [],
        tags = tags ?? [];

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['id'] ?? 0,
      json['title'] ?? '',
      json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
      json['chargeType'] ?? 0,
      json['isUnlock'] ?? false,
      json['previewMediaCount'] ?? 0,
      json['totalMediaCount'] ?? 0,
      json['files'] != null
          ? List<Files>.from(
              (json['files'] as List<dynamic>).map((e) => Files.fromJson(e)))
          : [],
      json['tags'] != null
          ? List<Tag>.from(
              (json['tags'] as List<dynamic>).map((e) => Tag.fromJson(e)))
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (supplier != null) {
      data['supplier'] = supplier!.toJson();
    }
    data['chargeType'] = chargeType;
    data['isUnlock'] = isUnlock;
    data['previewMediaCount'] = previewMediaCount;
    data['totalMediaCount'] = totalMediaCount;
    data['files'] =
        files.isNotEmpty ? files.map((e) => e.toJson()).toList() : [];
    data['tags'] = tags.isNotEmpty ? tags.map((e) => e.toJson()).toList() : [];
    return data;
  }
}

class Files {
  final String? path; // 文件路徑
  final String? cover; // 文件封面
  final int type; // 文件類型：1=圖片, 2=視頻

  Files(
    this.path,
    this.type,
    this.cover,
  );
  factory Files.fromJson(Map<String, dynamic> json) {
    return Files(
      json['path'] ?? '',
      json['type'] ?? 0,
      json['cover'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'cover': cover,
      'type': type,
    };
  }
}
