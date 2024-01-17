class RoomRank {
  int trank;
  List<RankItem> rank;
  List<RankItem> rank1;
  List<RankItem> rank7;
  List<RankItem> rank30;
  int amount;
  int users;

  RoomRank(
      {required this.trank,
      this.rank = const [],
      this.rank1 = const [],
      this.rank7 = const [],
      this.rank30 = const [],
      this.users = 0,
      this.amount = 0});

  factory RoomRank.fromJson(Map<String, dynamic> json) {
    return RoomRank(
      trank: json['trank'] as int,
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
      amount: json['amount'] as int,
      users: json['users'] as int,
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
      rank: json['rank'] as int,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String,
      amount: json['amount'] as double,
    );
  }
}
