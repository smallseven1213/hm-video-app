import 'package:logger/logger.dart';

final logger = Logger();

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

  factory DepositPaymentChannel.fromJsonWithNullCheck(
      Map<String, dynamic> json) {
    final nullFields = <String>[];
    final Map<String, dynamic> safeJson = <String, dynamic>{};

    json.forEach((key, value) {
      if (value == null) {
        nullFields.add(key);
      } else {
        safeJson[key] = value;
      }
    });

    if (nullFields.isNotEmpty) {
      logger.e('Null fields in $json: $nullFields');
    }

    return DepositPaymentChannel.fromJson(safeJson);
  }

  factory DepositPaymentChannel.fromJson(Map<String, dynamic> json) {
    List<String>? specificAmounts = json['specificAmounts']?.cast<String>();
    specificAmounts ??= [];

    return DepositPaymentChannel(
      id: json['id'] as int,
      name: json['name'] as String,
      tag: json['tag'] as int,
      amountType: json['amountType'] as int,
      specificAmounts: specificAmounts,
      maxAmount: json['maxAmount'] as int,
      minAmount: json['minAmount'] as int,
      discountRatio: json['discountRatio'] as String,
      isRecommend: json['isRecommend'] as bool,
      orderIndex: json['orderIndex'] as int,
    );
  }
}
