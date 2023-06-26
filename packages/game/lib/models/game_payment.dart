class Payment {
  final int id;
  final String? type;

  Payment(
    this.id,
    this.type,
  );

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      json['id'],
      json['paymentType'] ?? '',
    );
  }
}
