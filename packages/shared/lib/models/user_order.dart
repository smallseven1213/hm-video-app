import '../utils/datetime_formatter.dart';
import 'product.dart';
import 'payment_type.dart';

class Order {
  final String id;
  final String? amount;
  final int? status;
  final String? createdAt;
  final PaymentType? paymentType;
  final Product? product;

  Order(
    this.id, {
    this.amount,
    this.status,
    this.paymentType,
    this.createdAt,
    this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      json['id'],
      amount: json['amount'],
      status: json['status'],
      paymentType: json['payment_type'] != null
          ? PaymentType.fromJson(json['payment_type'])
          : PaymentType(),
      createdAt: formatDateTime(json['created_at']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(),
    );
  }
}
