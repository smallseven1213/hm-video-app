class GameOrder {
  final String id;
  final double? orderAmount;
  final int? paymentStatus;
  final String? createdAt;
  final String? paymentType;
  final Product? product;

  GameOrder(
    this.id, {
    this.orderAmount,
    this.paymentStatus,
    this.paymentType,
    this.createdAt,
    this.product,
  });

  factory GameOrder.fromJson(Map<String, dynamic> json) {
    return GameOrder(
      json['id'],
      orderAmount: double.parse(json['orderAmount'].toString()),
      paymentStatus: json['paymentStatus'],
      paymentType: json['paymentType'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] ?? '').toIso8601String(),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(),
    );
  }
}

class Product {
  final int? id;
  final List<Bundle>? bundles;
  final String? name;
  final String? subTitle;
  final int? type;
  final String? photoSid;
  final String? fiatMoneyPrice;
  final double? discount;
  final double? points;
  final String? colorHex;
  final String? description;
  final int? vipDays;
  final bool? isRebated;
  final int? orderIndex;
  final bool? enabled;
  final String? updatedAt;
  final String? balanceFiatMoneyPrice;

  Product({
    this.id,
    this.bundles,
    this.name,
    this.subTitle,
    this.type,
    this.photoSid,
    this.fiatMoneyPrice,
    this.discount,
    this.points,
    this.colorHex,
    this.description,
    this.vipDays,
    this.isRebated,
    this.orderIndex,
    this.enabled,
    this.updatedAt,
    this.balanceFiatMoneyPrice,
  });
  getProductImageUrl() =>
      // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$photoSid";
      photoSid;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      bundles: json['bundles'] == null
          ? []
          : List.from(json['bundles'] as List<dynamic>)
              .map((e) => Bundle.fromJson(e))
              .toList(),
      name: json['name'],
      subTitle: json['subTitle'],
      type: json['type'],
      photoSid: json['photoSid'],
      fiatMoneyPrice: json['fiatMoneyPrice'],
      discount: double.parse(json['balanceFiatMoneyPrice'] ?? '0.00'),
      points: json['points'] == null
          ? 0.00
          : double.parse(json['points'].toString()),
      colorHex: json['colorHex'],
      description: json['description'],
      vipDays: json['vipDays'],
      isRebated: json['isRebated'],
      orderIndex: json['orderIndex'],
      enabled: json['enabled'],
      updatedAt: json['updatedAt'],
      balanceFiatMoneyPrice: json['balanceFiatMoneyPrice'],
    );
  }
}

class Bundle {
  final int? id;
  final String? name;
  Bundle(this.id, this.name);
  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(json['id'], json['name']);
  }
}
