import 'package:shared/helpers/getField.dart';

class RoomRank {
  int trank;
  List<RankItem> current;
  List<RankItem> rank;
  List<RankItem> rank1;
  List<RankItem> rank7;
  List<RankItem> rank30;
  double amount;
  int users;

  RoomRank(
      {required this.trank,
      this.current = const [],
      this.rank = const [],
      this.rank1 = const [],
      this.rank7 = const [],
      this.rank30 = const [],
      this.users = 0,
      this.amount = 0});

  factory RoomRank.fromJson(Map<String, dynamic> json) {
    return RoomRank(
      trank: getField<int>(json, 'trank', defaultValue: 0),
      current: (json['current'] as List?)
              ?.map((item) => RankItem.fromJson(item))
              .toList() ??
          [],
      rank: (json['rank'] as List?)
              ?.map((item) => RankItem.fromJson(item))
              .toList() ??
          [],
      rank1: (json['rank1'] as List?)
              ?.map((item) => RankItem.fromJson(item))
              .toList() ??
          [],
      rank7: (json['rank7'] as List?)
              ?.map((item) => RankItem.fromJson(item))
              .toList() ??
          [],
      rank30: (json['rank30'] as List?)
              ?.map((item) => RankItem.fromJson(item))
              .toList() ??
          [],
      amount: getField<double>(json, 'amount', defaultValue: 0),
      users: getField<int>(json, 'users', defaultValue: 0),
    );
  }
}

class RankItem {
  int rank;
  String nickname;
  String avatar;
  double amount;

  RankItem(
      {required this.rank,
      required this.nickname,
      required this.avatar,
      required this.amount});

  factory RankItem.fromJson(Map<String, dynamic> json) {
    return RankItem(
      rank: getField(json, 'rank', defaultValue: 0),
      nickname: getField(json, 'nickname', defaultValue: ''),
      avatar: getField(json, 'avatar', defaultValue: ''),
      amount: getField<double>(json, 'amount', defaultValue: 0),
    );
  }
}
