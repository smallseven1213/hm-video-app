class GameItem {
  final int id;
  final String? tagId;
  final String gameId;
  final String? name;
  final int gameType;
  final String imgUrl;
  final int orderIndex;
  final String tpCode;
  final int direction;
  final int hotOrderIndex;

  GameItem({
    required this.id,
    this.tagId,
    required this.gameId,
    this.name,
    required this.gameType,
    required this.imgUrl,
    required this.orderIndex,
    required this.tpCode,
    required this.direction,
    required this.hotOrderIndex,
  });

  factory GameItem.fromJson(Map<String, dynamic> json) {
    try {
      return GameItem(
        id: _parseField(json, 'id', (value) => value as int),
        name: _parseField(
          json,
          'name',
          (value) => value as String?,
          orElse: () => '',
        ),
        gameId: _parseField(json, 'gameId', (value) => value as String),
        imgUrl: _parseField(json, 'imgUrl', (value) => value as String),
        orderIndex: _parseField(json, 'orderIndex', (value) => value as int),
        tagId: _parseField(
          json,
          'tagId',
          (value) => value as String,
          orElse: () => '',
        ),
        gameType: _parseField(json, 'gameType', (value) => value as int),
        tpCode: _parseField(json, 'tpCode', (value) => value as String),
        direction: _parseField(json, 'direction', (value) => value as int),
        hotOrderIndex:
            _parseField(json, 'hotOrderIndex', (value) => value as int),
      );
    } catch (e) {
      throw FormatException('Error parsing GameItem: $e');
    }
  }

  static T _parseField<T>(
    Map<String, dynamic> json,
    String key,
    T Function(dynamic) parse, {
    T Function()? orElse,
  }) {
    if (!json.containsKey(key)) {
      if (orElse != null) {
        return orElse();
      }
      throw FormatException('Missing required field: $key');
    }
    try {
      final value = json[key];
      if (value == null) {
        if (orElse != null) {
          return orElse();
        }
        throw FormatException('Field "$key" is null');
      }
      return parse(json[key]);
    } catch (e) {
      throw FormatException('Error parsing field "$key": $e');
    }
  }
}

class GameConfig {
  final bool? enabled;
  final bool? distributed;
  final int? paymentPage;
  final int? pageColor;
  final bool? needsPhoneVerification;
  final String? countryCode;
  final bool? isGameLobbyBalanceShow;

  GameConfig({
    this.enabled,
    this.distributed,
    this.paymentPage,
    this.pageColor,
    this.needsPhoneVerification,
    this.countryCode,
    this.isGameLobbyBalanceShow,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      enabled: json['enabled'],
      distributed: json['distributed'],
      paymentPage: json['paymentPage'],
      pageColor: json['pageColor'],
      needsPhoneVerification: json['isPhoneVerification'],
      countryCode: json['countryCode'],
      isGameLobbyBalanceShow: json['isGameLobbyBalance'],
    );
  }
}

Map<String, int> gameWebviewDirection = {
  'vertical': 1,
  'horizontal': 2,
};
