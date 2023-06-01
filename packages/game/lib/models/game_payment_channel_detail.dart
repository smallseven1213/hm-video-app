class GamePaymentChannelDetail {
  final String? branchName;
  final String receiptAccount;
  final String? receiptBank;
  final String receiptName;

  GamePaymentChannelDetail(
    this.branchName,
    this.receiptAccount,
    this.receiptBank,
    this.receiptName,
  );

  factory GamePaymentChannelDetail.fromJson(Map<String, dynamic> json) {
    return GamePaymentChannelDetail(
      json['branchName'],
      json['receiptAccount'],
      json['receiptBank'],
      json['receiptName'],
    );
  }
}
