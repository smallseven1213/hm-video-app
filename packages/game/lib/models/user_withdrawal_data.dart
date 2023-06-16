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
  int? remittanceType;
  String? legalName;
  String? bankName;
  String? branchName;

  UserPaymentSecurity(
      {this.account,
      this.remittanceType,
      this.legalName,
      this.bankName,
      this.branchName});

  UserPaymentSecurity.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    remittanceType = json['remittanceType'];
    legalName = json['legalName'];
    bankName = json['bankName'];
    branchName = json['branchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account'] = account;
    data['remittanceType'] = remittanceType;
    data['legalName'] = legalName;
    data['bankName'] = bankName;
    data['branchName'] = branchName;
    return data;
  }
}
