// 各種錢包資訊的統一格式

// 做一個enum , 主錢包=0, wali錢包=1
enum WalletType { main, wali }

class WalletItem {
  WalletType? type; // 如果為0，表示為主錢包, 1為wali
  double? amount;

  WalletItem({this.type, this.amount});

  WalletItem.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['amount'] = amount;
    return data;
  }
}
