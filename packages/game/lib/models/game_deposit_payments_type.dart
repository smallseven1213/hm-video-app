class DepositPaymentsType {
  final int id;
  final String name;
  final String code;
  final List<String>? specificAmounts;
  final String maxAmount;
  final String minAmount;
  final int orderIndex;
  final String icon;
  final List<String> label;
  final int requireName;
  final int requirePhone;

  DepositPaymentsType({
    required this.id,
    required this.name,
    required this.code,
    required this.specificAmounts,
    required this.maxAmount,
    required this.minAmount,
    required this.orderIndex,
    required this.icon,
    required this.label,
    required this.requireName,
    required this.requirePhone,
  });

  factory DepositPaymentsType.fromJson(Map<String, dynamic> json) {
    return DepositPaymentsType(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      specificAmounts: json['specificAmounts'] != null
          ? List<String>.from(json['specificAmounts'] as List<dynamic>)
          : [],
      maxAmount: json['maxAmount'] as String,
      minAmount: json['minAmount'] as String,
      orderIndex: json['orderIndex'] as int,
      icon: json['icon'] as String,
      label: List<String>.from(json['label'] as List<dynamic>),
      requireName: json['requireName'] as int,
      requirePhone: json['requirePhone'] as int,
    );
  }
}
