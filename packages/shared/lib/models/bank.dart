import 'dart:convert';

class BankItem {
  BankItem({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.photoUrl,
    required this.orderIndex,
  });

  final int id;
  final String bankCode;
  final String bankName;
  final String photoUrl;
  final int orderIndex;

  factory BankItem.fromRawJson(String str) =>
      BankItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankItem.fromJson(Map<String, dynamic> json) => BankItem(
        id: json["id"],
        bankCode: json["bankCode"],
        bankName: json["bankName"],
        photoUrl: json["photoUrl"],
        orderIndex: json["orderIndex"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bankCode": bankCode,
        "bankName": bankName,
        "photoUrl": photoUrl,
        "orderIndex": orderIndex,
      };
}
