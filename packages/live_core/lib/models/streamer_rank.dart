class StreamerRank {
  final int id;
  final String nickname;
  final String avatar;
  final int rank;
  final bool isLiving;
  final bool isFollow;
  

  StreamerRank({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.rank,
    required this.isLiving,
    required this.isFollow,
  });

  factory StreamerRank.fromJson(Map<String, dynamic> json) {
    return StreamerRank(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String,
      rank: json['rank'] as int,
      isLiving: json['is_living'] == 1,
      isFollow: json['is_follow'] == 1,
    );
  }
}

enum RankType {
  none,
  income,
  popularity,
  liveTimes,
}

enum TimeType {
  none,
  today,
  thisWeek,
  thisMonth,
}
