class DepositPaymentTypeList {
  final int id;
  final String name;
  final String code;
  final List<dynamic> label;
  final String icon;
  final int requireName;

  DepositPaymentTypeList(
    this.id,
    this.name,
    this.code,
    this.label,
    this.icon,
    this.requireName,
  );

  factory DepositPaymentTypeList.fromJson(Map<String, dynamic> json) {
    return DepositPaymentTypeList(
      json['id'],
      json['name'],
      json['code'],
      json['label'],
      json['icon'],
      json['requireName'],
    );
  }
}
