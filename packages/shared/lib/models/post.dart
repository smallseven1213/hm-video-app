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
  final List<Tag> tags; // 標籤陣列
  final String? content; // 貼文內容
  final int? viewCount; // 貼文觀看數
  final int? likeCount; // 貼文點讚數
  final String? cover; // 封面
  final int? replyCount; // 回覆數
  final int? linkType; // 連結類型
  final String? link; // 連結
  final bool? isLike; // 是否點讚
  final int? totalChapter; // 總章節數

  Post(
    this.id,
    this.title,
    this.supplier,
    this.chargeType,
    this.isUnlock,
    this.previewMediaCount,
    this.totalMediaCount,
    this.content,
    List<Files>? files,
    List<Tag>? tags,
    this.cover,
    this.replyCount,
    this.linkType,
    this.link,
    this.viewCount,
    this.likeCount,
    this.isLike,
    this.totalChapter,
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
      json['content'],
      (json['files'] as List<dynamic>?)
          ?.map((file) => Files.fromJson(file))
          .toList(),
      (json['tags'] as List<dynamic>?)
          ?.map((tag) => Tag.fromJson(tag))
          .toList(),
      json['cover'],
      json['replyCount'],
      json['linkType'],
      json['link'],
      json['viewCount'],
      json['likeCount'],
      json['isLike'],
      json['totalChapter'] ?? 0,
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
    data['content'] = content;
    data['viewCount'] = viewCount;
    data['likeCount'] = likeCount;
    data['cover'] = cover;
    data['replyCount'] = replyCount;
    data['linkType'] = linkType;
    data['link'] = link;
    data['isLike'] = isLike;
    data['files'] =
        files.isNotEmpty ? files.map((e) => e.toJson()).toList() : [];
    data['tags'] = tags.isNotEmpty ? tags.map((e) => e.toJson()).toList() : [];
    data['totalChapter'] = totalChapter;
    return data;
  }
}

class Files {
  final String video; // 文件路徑
  final String cover; // 文件封面
  final int type; // 文件類型：1=圖片, 2=視頻

  Files(
    this.video,
    this.type,
    this.cover,
  );
  factory Files.fromJson(Map<String, dynamic> json) {
    return Files(
      json['video'] ?? '',
      json['type'] ?? 0,
      json['cover'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video,
      'cover': cover,
      'type': type,
    };
  }
}
