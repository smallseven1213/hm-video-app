import 'package:shared/helpers/getField.dart';

class StreamerProfile {
  final int id;
  final String nickname;
  final String? avatar;
  final String? createdAt;
  final int? fansCount;
  final String? account;
  final bool? isLive;
  final int? supplierId;

  StreamerProfile({
    required this.id,
    required this.nickname,
    this.supplierId,
    this.avatar,
    this.createdAt,
    this.fansCount,
    this.account,
    this.isLive,
  });

  factory StreamerProfile.fromJson(Map<String, dynamic> json) {
    return StreamerProfile(
      id: getField<int>(json, 'streamer_id', defaultValue: 0),
      supplierId: getField<int>(json, 'supplier_id', defaultValue: 0),
      nickname: getField<String>(json, 'nickname', defaultValue: ''),
      avatar: getField<String>(json, 'avatar', defaultValue: ''),
      createdAt: getField<String>(json, 'created_at', defaultValue: ''),
      fansCount: getField<int>(json, 'fans_count', defaultValue: 0),
      account: getField<String>(json, 'account', defaultValue: ''),
      isLive:
          getField<int>(json, 'is_live', defaultValue: 0) == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'account': account,
      'nickname': nickname,
      'avatar': avatar,
      'created_at': createdAt,
      'fans_count': fansCount,
      'is_live': isLive,
    };
  }
}
