import 'package:shared/models/product.dart';

class GameOrder {
  final String id;
  final double? orderAmount;
  final int? paymentStatus;
  final String? createdAt;
  final String? paymentType;
  final Product? product;

  GameOrder(
    this.id, {
    this.orderAmount,
    this.paymentStatus,
    this.paymentType,
    this.createdAt,
    this.product,
  });

  factory GameOrder.fromJson(Map<String, dynamic> json) {
    return GameOrder(
      json['id'],
      orderAmount: double.parse(json['orderAmount'].toString()),
      paymentStatus: json['paymentStatus'],
      paymentType: json['paymentType'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] ?? '').toIso8601String(),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(),
    );
  }
}
