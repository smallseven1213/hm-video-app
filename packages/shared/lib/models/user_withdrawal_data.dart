class UserWithdrawalData {
  List<UserPaymentSecurity>? userPaymentSecurity;
  int? points;
  bool? paymentPin;

  UserWithdrawalData({this.userPaymentSecurity, this.points, this.paymentPin});

  UserWithdrawalData.fromJson(Map<String, dynamic> json) {
    if (json['userPaymentSecurity'] != null) {
      userPaymentSecurity = <UserPaymentSecurity>[];
      json['userPaymentSecurity'].forEach((v) {
        userPaymentSecurity!.add(UserPaymentSecurity.fromJson(v));
      });
    }
    points = json['points'];
    paymentPin = json['paymentPin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userPaymentSecurity != null) {
      data['userPaymentSecurity'] =
          this.userPaymentSecurity!.map((v) => v.toJson()).toList();
    }
    data['points'] = this.points;
    data['paymentPin'] = this.paymentPin;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['remittanceType'] = this.remittanceType;
    data['legalName'] = this.legalName;
    data['bankName'] = this.bankName;
    data['branchName'] = this.branchName;
    return data;
  }
}
