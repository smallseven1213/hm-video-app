class Navigation {
  final int id;
  final String name;
  final String rule;

  Navigation({
    required this.id,
    required this.name,
    required this.rule,
  });

  factory Navigation.fromJson(Map<String, dynamic> json) {
    return Navigation(
      id: json['id'],
      name: json['name'],
      rule: json['rule'],
    );
  }
}
