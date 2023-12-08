class ThirdLoginData {
  String amount;
  String balance;
  String token;
  String apiHost;

  ThirdLoginData({
    required this.amount,
    required this.balance,
    required this.token,
    required this.apiHost,
  });

  factory ThirdLoginData.fromJson(Map<String, dynamic> json) {
    return ThirdLoginData(
      amount: json['amount'],
      balance: json['balance'],
      token: json['token'],
      apiHost: json['apiHost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'balance': balance,
      'token': token,
      'apiHost': apiHost,
    };
  }
}
