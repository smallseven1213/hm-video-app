import 'channel_info.dart';
import 'tag.dart'; // Assuming Tag class is defined elsewhere appropriately.

class Game implements ContentBlock {
  final int id;
  final String name;
  final int template;
  final int gameType;
  final List<GameDetail> games;

  Game({
    required this.id,
    required this.name,
    required this.template,
    required this.gameType,
    required this.games,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      template: json['template'],
      gameType: json['gameType'],
      games: List<GameDetail>.from(
          json['games'].map((x) => GameDetail.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'template': template,
      'gameType': gameType,
      'games': games.map((game) => game.toJson()).toList(),
    };
  }
  
  @override
  // TODO: implement blockType
  int get blockType => throw UnimplementedError();
}

class GameDetail {
  final String gameId;
  final String gameUrl;
  final String verticalLogo;
  final String horizontalLogo;
  final String jackpot;
  final int multiple;
  final String name;
  List<Tag>? tags;

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
      tags: json['tags'] != null
          ? List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x)))
          : null,
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
      'tags': tags?.map((tag) => tag.toJson()).toList(),
    };
  }
}
