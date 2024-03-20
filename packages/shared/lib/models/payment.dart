class Payment {
  final int id;
  final String type;
  final String? iconSid;

  Payment(
    this.id,
    this.type,
    this.iconSid,
  );

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      json['id'],
      json['paymentTypeName'],
      json['paymentTypeIcon'],
    );
  }
}
