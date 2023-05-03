class GameItem {
  final int gameId;
  final String gameName;
  final int gameType;
  final int hotOrderIndex;
  final String imgUrl;
  final int orderIndex;

  GameItem(this.gameId, this.gameName, this.gameType, this.hotOrderIndex,
      this.imgUrl, this.orderIndex);

  factory GameItem.fromJson(Map<String, dynamic> json) {
    return GameItem(
      json['gameId'],
      json['gameName'],
      json['gameType'],
      json['hotOrderIndex'],
      json['imgUrl'],
      json['orderIndex'],
    );
  }
}

class GameConfig {
  final bool enabled;
  final bool distributed;
  final int paymentPage;
  final int pageColor;

  GameConfig(this.enabled, this.distributed, this.paymentPage, this.pageColor);

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      json['enabled'],
      json['distributed'],
      json['paymentPage'],
      json['pageColor'],
    );
  }
}
