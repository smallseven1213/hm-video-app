class Gift {
  final int id;
  final String name;
  final String image;
  final String description;
  final String price;
  final String animation;
  final int animationTime;
  final int sorting;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Gift({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.animation,
    required this.animationTime,
    required this.sorting,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      price: json['price'],
      animation: json['animation'],
      animationTime: json['animation_time'],
      sorting: json['sorting'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
