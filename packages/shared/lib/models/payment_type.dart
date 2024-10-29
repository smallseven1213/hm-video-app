class PaymentType {
  final String? code;
  final String? icon;
  final String? label;
  final String? name;

  PaymentType({
    this.code,
    this.icon,
    this.label,
    this.name,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      code: json['code'],
      icon: json['icon'],
      label: json['label'],
      name: json['name'],
    );
  }
}
