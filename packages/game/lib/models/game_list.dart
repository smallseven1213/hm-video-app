class GameItem {
  final int gameId;
  final String gameName;
  final int gameType;
  final int hotOrderIndex;
  final String imgUrl;
  final int orderIndex;
  final String tpCode;
  final int direction;

  GameItem(this.gameId, this.gameName, this.gameType, this.hotOrderIndex,
      this.imgUrl, this.orderIndex, this.tpCode, this.direction);

  factory GameItem.fromJson(Map<String, dynamic> json) {
    return GameItem(
      json['gameId'],
      json['gameName'],
      json['gameType'],
      json['hotOrderIndex'],
      json['imgUrl'],
      json['orderIndex'],
      json['tpCode'],
      json['direction'],
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

List gameCategoriesMapper = [
  {
    'name': '全部',
    'gameType': 0,
    'icon': 'packages/game/assets/images/game_lobby/menu-all@3x.webp',
  },
  {
    'name': '最近',
    'gameType': -1,
    'icon': 'packages/game/assets/images/game_lobby/menu-new@3x.webp',
  },
  {
    'name': '捕魚',
    'gameType': 1,
    'icon': 'packages/game/assets/images/game_lobby/menu-fish@3x.webp',
  },
  {
    'name': '真人',
    'gameType': 2,
    'icon': 'packages/game/assets/images/game_lobby/menu-live@3x.webp',
  },
  {
    'name': '棋牌',
    'gameType': 3,
    'icon': 'packages/game/assets/images/game_lobby/menu-poker@3x.webp',
  },
  {
    'name': '電子',
    'gameType': 4,
    'icon': 'packages/game/assets/images/game_lobby/menu-slot@3x.webp',
  },
  {
    'name': '體育',
    'gameType': 5,
    'icon': 'packages/game/assets/images/game_lobby/menu-sport@3x.webp',
  },
  {
    'name': '彩票',
    'gameType': 6,
    'icon': 'packages/game/assets/images/game_lobby/menu-lottery@3x.webp',
  }
];
