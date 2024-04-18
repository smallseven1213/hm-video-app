class Game {
  final int id;
  final String name;
  final int template;
  final int gameType;
  final bool isRecommend;
  final bool isJackpot;
  final List<GameDetail> games;

  Game({
    required this.id,
    required this.name,
    required this.template,
    required this.gameType,
    required this.isRecommend,
    required this.isJackpot,
    required this.games,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      template: json['template'],
      gameType: json['gameType'],
      isRecommend: json['isRecommend'],
      isJackpot: json['isJackpot'],
      games: List<GameDetail>.from(
          json['games'].map((x) => GameDetail.fromJson(x))),
    );
  }
}

class GameDetail {
  final String gameId;
  final String gameUrl;
  final String verticalLogo;
  final String horizontalLogo;
  final String jackpot;
  final String multiple;
  final String name;
  final List<dynamic>? tags;

  GameDetail({
    required this.gameId,
    required this.gameUrl,
    required this.verticalLogo,
    required this.horizontalLogo,
    required this.jackpot,
    required this.multiple,
    required this.name,
    this.tags,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      gameId: json['gameId'],
      gameUrl: json['gameUrl'],
      verticalLogo: json['verticalLogo'],
      horizontalLogo: json['horizontalLogo'],
      jackpot: json['jackpot'],
      multiple: json['multiple'],
      name: json['name'],
      tags: json['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'gameUrl': gameUrl,
      'verticalLogo': verticalLogo,
      'horizontalLogo': horizontalLogo,
      'jackpot': jackpot,
      'multiple': multiple,
      'name': name,
      'tags': tags,
    };
  }
}
