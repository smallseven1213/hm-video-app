class BundlingProduct {
  final int id;
  final String? name;
  final int? type;
  final int? quantity;
  final int? orderIndex;
  final bool? enabled;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  BundlingProduct(
    this.id, {
    this.name,
    this.type,
    this.quantity,
    this.orderIndex,
    this.enabled,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BundlingProduct.fromJson(Map<String, dynamic> json) {
    return BundlingProduct(
      json['id'],
      name: json['name'],
      type: json['type'],
      quantity: json['quantity'],
      orderIndex: json['orderIndex'],
      enabled: json['enabled'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
