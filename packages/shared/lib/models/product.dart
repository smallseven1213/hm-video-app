class Bundle {
  final int? id;
  final String? name;
  Bundle(this.id, this.name);
  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(json['id'], json['name']);
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
      name: json['name'], // 品名
      subTitle: json['subTitle'], // 說明
      type: json['type'],
      photoSid: json['photoSid'],
      fiatMoneyPrice: json['fiatMoneyPrice'], // 原價
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
      balanceFiatMoneyPrice: json['balanceFiatMoneyPrice'], // 實際售價
    );
  }
}
