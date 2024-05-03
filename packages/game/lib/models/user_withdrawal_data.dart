class UserWithdrawalData {
  List<UserPaymentSecurity>? userPaymentSecurity;
  double? points;
  bool? paymentPin;

  UserWithdrawalData({this.userPaymentSecurity, this.points, this.paymentPin});

  UserWithdrawalData.fromJson(Map<String, dynamic> json) {
    if (json['userPaymentSecurity'] != null) {
      userPaymentSecurity = <UserPaymentSecurity>[];
      json['userPaymentSecurity'].forEach((v) {
        userPaymentSecurity!.add(UserPaymentSecurity.fromJson(v));
      });
    }
    points = json['points'].toDouble() ?? 0.00;
    paymentPin = json['paymentPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userPaymentSecurity != null) {
      data['userPaymentSecurity'] =
          userPaymentSecurity!.map((v) => v.toJson()).toList();
    }
    data['points'] = points;
    data['paymentPin'] = paymentPin;
    return data;
  }
}

class UserPaymentSecurity {
  String? account;
  int remittanceType;
  String? remittanceTypeName;
  String? legalName;
  String? bankName;
  String? branchName;
  bool isBound;

  UserPaymentSecurity(
      {this.account,
      required this.remittanceType,
      this.remittanceTypeName,
      this.legalName,
      this.bankName,
      this.branchName,
      required this.isBound});

  factory UserPaymentSecurity.fromJson(Map<String, dynamic> json) {
    return UserPaymentSecurity(
      account: json['account'],
      remittanceType: json['remittanceType'],
      remittanceTypeName: json['remittanceTypeName'],
      legalName: json['legalName'],
      bankName: json['bankName'],
      branchName: json['branchName'],
      isBound: json['isBound'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account'] = account;
    data['remittanceType'] = remittanceType;
    data['remittanceTypeName'] = remittanceTypeName;
    data['legalName'] = legalName;
    data['bankName'] = bankName;
    data['branchName'] = branchName;
    data['isBound'] = isBound;
    return data;
  }
}

Map<String, int> remittanceTypeEnum = {
  'BANK_CARD_CNY': 1,
  'USDT': 2,
  'BANK_CARD_IDR': 3,
  'BANK_CARD_TWD': 4,
  'BANK_CARD_PHP': 5,
};

enum Type { usdt, bankcard }

Map<int, Type> remittanceTypeMapper = {
  1: Type.bankcard,
  2: Type.usdt,
  3: Type.bankcard,
  4: Type.bankcard,
  5: Type.bankcard,
};
