import 'post.dart';

class InfinityPosts {
  final List<Post> posts;
  final int totalCount;
  final bool hasMoreData;

  InfinityPosts(this.posts, this.totalCount, this.hasMoreData);
}
