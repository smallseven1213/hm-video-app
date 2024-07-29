

import 'post.dart';

class PostDetail {
  final Post post;
  final List<Series> series;
  final List<Recommend> recommend;

  PostDetail({
	required this.post,
	required this.series,
	required this.recommend,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
	return PostDetail(
	  post: Post.fromJson(json['post']),
	  series: json['series'] != null
		  ? List<Series>.from(
			  (json['series'] as List<dynamic>).map((e) => Series.fromJson(e)))
		  : [],
	  recommend: json['recommend'] != null
		  ? List<Recommend>.from((json['recommend'] as List<dynamic>)
			  .map((e) => Recommend.fromJson(e)))
		  : [],
	);
  }

  Map<String, dynamic> toJson() {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['post'] = post.toJson();
	data['series'] =
		series.isNotEmpty ? series.map((e) => e.toJson()).toList() : [];
	data['recommend'] =
		recommend.isNotEmpty ? recommend.map((e) => e.toJson()).toList() : [];
	return data;
  }
}

class Series {
  final int id;
  final String title;
  final String cover;

  Series({
	required this.id,
	required this.title,
	required this.cover,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
	return Series(
	  id: json['id'] ?? 0,
	  title: json['title'] ?? '',
	  cover: json['cover'] ?? '',
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'id': id,
	  'title': title,
	  'cover': cover,
	};
  }
}

class Recommend {
  final int id;
  final String title;
  final String cover;

  Recommend({
	required this.id,
	required this.title,
	required this.cover,
  });

  factory Recommend.fromJson(Map<String, dynamic> json) {
	return Recommend(
	  id: json['id'] ?? 0,
	  title: json['title'] ?? '',
	  cover: json['cover'] ?? '',
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'id': id,
	  'title': title,
	  'cover': cover,
	};
  }
}