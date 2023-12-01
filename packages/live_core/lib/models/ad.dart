class Ad {
  final int id;
  final String title;
  final String image;
  final String link;

  Ad({
    required this.id,
    required this.title,
    required this.image,
    required this.link,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      link: json['link'],
    );
  }
}
