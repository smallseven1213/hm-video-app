class GameWithdrawStackLimit {
  final bool reachable;
  final String stakeLimit;
  final String validStake;

  GameWithdrawStackLimit(
    this.reachable,
    this.stakeLimit,
    this.validStake,
  );

  factory GameWithdrawStackLimit.fromJson(Map<String, dynamic> json) {
    return GameWithdrawStackLimit(
      json['reachable'],
      json['stakeLimit'],
      json['validStake'],
    );
  }
}

class GameParamConfig {
  final String withdrawalFee;
  final String withdrawalMode;
  final String withdrawalLowerLimit;
  final String? appDownload;
  final String? activityEntrance;

  GameParamConfig({
    required this.withdrawalFee,
    required this.withdrawalMode,
    required this.withdrawalLowerLimit,
    this.appDownload,
    this.activityEntrance,
  });

  factory GameParamConfig.fromJson(Map<String, dynamic> json) {
    return GameParamConfig(
      withdrawalFee: json['WITHDRAWAL_FEE'],
      withdrawalMode: json['WITHDRAWAL_MODE'],
      withdrawalLowerLimit: json['WITHDRAWAL_LOWER_LIMIT'],
      appDownload: json['APP_DOWNLOAD'],
      activityEntrance: json['ACTIVITY_ENTRANCE'],
    );
  }
}

Map<String, String> withdrawalModeMapper = {
  '1': 'disable',
  '2': 'enable',
};
