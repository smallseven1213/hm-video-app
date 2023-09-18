import '../utils/datetime_formatter.dart';
import 'product.dart';

class Order {
  final String id;
  final double? orderAmount;
  final int? paymentStatus;
  final String? createdAt;
  final String? paymentType;
  final Product? product;

  Order(
    this.id, {
    this.orderAmount,
    this.paymentStatus,
    this.paymentType,
    this.createdAt,
    this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      json['id'],
      orderAmount: double.parse(json['orderAmount'].toString()),
      paymentStatus: json['paymentStatus'],
      paymentType: json['paymentType'],
      createdAt: formatDateTime(json['createdAt']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(),
    );
  }
}
