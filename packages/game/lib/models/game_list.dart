class GameItem {
  final int id;
  final String tagId;
  final String gameId;
  final String gameName;
  final int gameType;
  final String imgUrl;
  final int orderIndex;
  final String tpCode;
  final int direction;
  final int hotOrderIndex;

  GameItem(
      this.id,
      this.tagId,
      this.gameId,
      this.gameName,
      this.gameType,
      this.imgUrl,
      this.orderIndex,
      this.tpCode,
      this.direction,
      this.hotOrderIndex);

  factory GameItem.fromJson(Map<String, dynamic> json) {
    return GameItem(
      json['id'],
      json['tagId'],
      json['gameId'],
      json['gameName'],
      json['gameType'],
      json['imgUrl'],
      json['orderIndex'],
      json['tpCode'],
      json['direction'],
      json['hotOrderIndex'],
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

Map<String, int> gameWebviewDirection = {
  'vertical': 1,
  'horizontal': 2,
};
