import '../utils/datetime_formatter.dart';
import 'product.dart';

class Order {
  final String id;
  final String? orderAmount;
  final int? paymentStatus;
  final String? createdAt;
  final String? paymentType;
  final int? productId;

  Order(
    this.id, {
    this.orderAmount,
    this.paymentStatus,
    this.paymentType,
    this.createdAt,
    this.productId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      json['id'],
      orderAmount: json['orderAmount'],
      paymentStatus: json['paymentStatus'],
      paymentType: json['paymentType'],
      createdAt: formatDateTime(json['createdAt']),
      productId: json['product'],
    );
  }
}
