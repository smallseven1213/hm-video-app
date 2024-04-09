class DepositPaymentChannel {
  final int id;
  final String name;
  final int tag;
  final int amountType;
  final List<String>? specificAmounts;
  final int maxAmount;
  final int minAmount;
  final String discountRatio;
  final bool isRecommend;
  final int orderIndex;

  DepositPaymentChannel({
    required this.id,
    required this.name,
    required this.tag,
    required this.amountType,
    required this.specificAmounts,
    required this.maxAmount,
    required this.minAmount,
    required this.discountRatio,
    required this.isRecommend,
    required this.orderIndex,
  });

  factory DepositPaymentChannel.fromJson(Map<String, dynamic> json) {
    return DepositPaymentChannel(
      id: json['id'] as int,
      name: json['name'] as String,
      tag: json['tag'] as int,
      amountType: json['amountType'] as int,
      specificAmounts: json['specificAmounts'] != null
          ? List<String>.from(json['specificAmounts'] as List<dynamic>)
          : [],
      maxAmount: json['maxAmount'] as int,
      minAmount: json['minAmount'] as int,
      discountRatio: json['discountRatio'] as String,
      isRecommend: json['isRecommend'] as bool,
      orderIndex: json['orderIndex'] as int,
    );
  }
}
