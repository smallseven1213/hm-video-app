class Payment {
  final int id;
  final String? paymentType;
  final String? paymentTypeName;

  Payment(
    this.id,
    this.paymentType,
    this.paymentTypeName,
  );

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      json['id'],
      json['paymentType'] ?? '',
      json['paymentTypeName'] ?? '',
    );
  }
}
