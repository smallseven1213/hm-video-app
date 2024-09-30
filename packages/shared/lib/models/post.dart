import 'package:shared/models/supplier.dart';
import 'package:shared/models/tag.dart';
import 'package:shared/helpers/get_field.dart';

enum LinkType {
  none,
  video,
  comic,
  link,
}

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
  final int? linkType; // 1: 影片, 2: 漫畫, 3: 連結,
  final String? link; // 連結
  final bool? isLike; // 是否點讚
  final int? totalChapter; // 總章節數
  final String? points; // 解鎖所需金幣數量

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
    this.points,
  )   : files = files ?? [],
        tags = tags ?? [];

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        getField(json, 'id', defaultValue: 0),
        getField(json, 'title', defaultValue: ''),
        Supplier.fromJson(getField(json, 'supplier', defaultValue: {})),
        getField(json, 'chargeType', defaultValue: 0),
        getField(json, 'isUnlock', defaultValue: false),
        getField(json, 'previewMediaCount', defaultValue: 0),
        getField(json, 'totalMediaCount', defaultValue: 0),
        getField(json, 'content', defaultValue: ''),
        getField(json, 'files', defaultValue: [])
            .map<Files>((file) => Files.fromJson(file))
            .toList(),
        getField(json, 'tags', defaultValue: [])
            .map<Tag>((tag) => Tag.fromJson(tag))
            .toList(),
        getField(json, 'cover', defaultValue: ''),
        getField(json, 'replyCount', defaultValue: 0),
        getField(json, 'linkType', defaultValue: 0),
        getField(json, 'link', defaultValue: ''),
        getField(json, 'viewCount', defaultValue: 0),
        getField(json, 'likeCount', defaultValue: 0),
        getField(json, 'isLike', defaultValue: false),
        getField(json, 'totalChapter', defaultValue: 0),
        getField(json, 'points', defaultValue: '0').toString(),
      );
    } catch (e) {
      print('Error parsing Post from JSON: $e');
      return Post(
        0, // id
        '', // title
        null, // supplier
        0, // chargeType
        false, // isUnlock
        0, // previewMediaCount
        0, // totalMediaCount
        null, // content
        [], // files
        [], // tags
        null, // cover
        0, // replyCount
        null, // linkType
        null, // link
        0, // viewCount
        0, // likeCount
        false, // isLike
        0, // totalChapter
        '0', // points
      );
    }
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
    data['points'] = points;
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
      getField(json, 'video', defaultValue: ''),
      getField(json, 'type', defaultValue: 0),
      getField(json, 'cover', defaultValue: ''),
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
