class Command {
  final int id;
  final String name;
  final String description;
  final String price;

  Command({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
