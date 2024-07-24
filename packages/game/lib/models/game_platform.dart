class GamePlatformItem {
  final int id;
  final String tpCode;
  final int gameType;
  final int status;
  final String gamePlatformName;
  final int supportDevice;
  final int orderIndex;
  final int launchMode;
  final String photoId;
  final String? logo;

  GamePlatformItem({
    required this.id,
    required this.tpCode,
    required this.gameType,
    required this.status,
    required this.gamePlatformName,
    required this.supportDevice,
    required this.orderIndex,
    required this.launchMode,
    required this.photoId,
    this.logo,
  });

  factory GamePlatformItem.fromJson(Map<String, dynamic> json) {
    return GamePlatformItem(
      id: json['id'] as int,
      tpCode: json['tpCode'] as String,
      gameType: json['gameType'] as int,
      status: json['status'] as int,
      gamePlatformName: json['gamePlatformName'] as String,
      supportDevice: json['supportDevice'] as int,
      orderIndex: json['orderIndex'] as int,
      launchMode: json['launchMode'] as int,
      photoId: json['photoId'] as String,
      logo: json['logo'] as String?,
    );
  }
}
