class UserWithdrawalData {
  double? points;
  bool? paymentPin;
  List<UserPaymentSecurity>? userPaymentSecurity;
  List<UserKyc>? userKyc;

  UserWithdrawalData({
    this.points,
    this.paymentPin,
    this.userPaymentSecurity,
    this.userKyc,
  });

  UserWithdrawalData.fromJson(Map<String, dynamic> json) {
    points = json['points'].toDouble() ?? 0.00;
    paymentPin = json['paymentPin'];

    if (json['userPaymentSecurity'] != null) {
      userPaymentSecurity = <UserPaymentSecurity>[];
      json['userPaymentSecurity'].forEach((v) {
        userPaymentSecurity!.add(UserPaymentSecurity.fromJson(v));
      });
    }

    if (json['userKyc'] != null) {
      userKyc = <UserKyc>[];
      json['userKyc'].forEach((v) {
        userKyc!.add(UserKyc.fromJson(v));
      });
    }
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

class UserKyc {
  int kycType;
  String? kycTypeName;
  int? status;
  bool isBound;

  UserKyc({
    required this.kycType,
    this.kycTypeName,
    this.status,
    required this.isBound,
  });

  factory UserKyc.fromJson(Map<String, dynamic> json) {
    return UserKyc(
      kycType: json['kycType'],
      kycTypeName: json['kycTypeName'],
      status: json['status'],
      isBound: json['isBound'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kycType'] = kycType;
    data['kycTypeName'] = kycTypeName;
    data['status'] = status;
    data['isBound'] = isBound;
    return data;
  }
}

enum Type { usdt, bankcard }

Map<String, int> remittanceTypeEnum = {
  'BANK_CARD_CNY': 1,
  'USDT': 2,
  'BANK_CARD_IDR': 3,
  'BANK_CARD_TWD': 4,
  'BANK_CARD_PHP': 5,
};

Map<int, Type> remittanceTypeMapper = {
  1: Type.bankcard,
  2: Type.usdt,
  3: Type.bankcard,
  4: Type.bankcard,
  5: Type.bankcard,
};

enum KycType { cellPhone, idCard }

Map<String, int> kycTypeEnum = {
  'CELL_PHONE': 1,
  'ID_CARD': 2,
};

Map<int, KycType> kycTypeMapper = {
  1: KycType.cellPhone,
  2: KycType.idCard,
};

Map<String, int> idCardStatusEnum = {
  // 審核中
  'REVIEWING': 1,
  // 已通過
  'PASSED': 2,
  // 已拒絕
  'REJECTED': 3,
};
