class WithdrawalRecord {
  final String? id;
  final String? account;
  final int? remittanceType;
  final int? status;
  final String? applyAmount;
  final String? auditDate;
  final String? updatedAt;

  WithdrawalRecord(
    this.id,
    this.account,
    this.remittanceType,
    this.status,
    this.applyAmount,
    this.auditDate,
    this.updatedAt,
  );

  factory WithdrawalRecord.fromJson(Map<String, dynamic> json) {
    return WithdrawalRecord(
      json['id'],
      json['account'], // 提款帳戶
      json['remittanceType'], // 類型
      json['status'], // 狀態
      json['applyAmount'], // 提款金額
      json['auditDate'], // 申請時間
      json['updatedAt'], // 更新時間
    );
  }
}
