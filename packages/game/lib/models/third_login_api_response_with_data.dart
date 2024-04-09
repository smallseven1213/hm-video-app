class ThirdLoginApiResponseBaseWithData<T> {
  int? code;
  ThirdLoginData? data;

  ThirdLoginApiResponseBaseWithData({this.code, this.data});

  ThirdLoginApiResponseBaseWithData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = ThirdLoginData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['data'] = data;
    return data;
  }
}

class ThirdLoginData {
  String amount;
  String balance;
  String token;
  String apiHost;
  String currency;

  ThirdLoginData({
    required this.amount,
    required this.balance,
    required this.token,
    required this.apiHost,
    required this.currency,
  });

  factory ThirdLoginData.fromJson(Map<String, dynamic> json) {
    return ThirdLoginData(
      amount: json['amount'],
      balance: json['balance'],
      token: json['token'],
      apiHost: json['apiHost'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'balance': balance,
      'token': token,
      'apiHost': apiHost,
      'currency': currency,
    };
  }
}

Map currencyMapper = {
  'TWD': 'zh-TW',
  'USD': 'en-US',
  'CNY': 'zh-CN',
  'IDR': 'id-ID',
  'VND': 'vi-VN',
};
