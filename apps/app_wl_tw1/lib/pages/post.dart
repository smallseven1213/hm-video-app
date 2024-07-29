import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/post/post_provider.dart';
import 'package:shared/modules/post/post_consumer.dart';
import 'package:shared/widgets/posts/follow_button.dart';

// 定義顏色配置
class AppColors {
  static const lightBackground = Colors.white;
  static const darkBackground = Colors.black54;
  static const lightText = Colors.black;
  static const darkText = Colors.white;
  static const lightButton = Colors.pink;
  static const darkButton = Colors.deepOrange;
}

class PostPage extends StatelessWidget {
  final int id;
  final bool? isDarkMode;

  const PostPage({
    Key? key,
    required this.id,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostConsumer(
      id: id,
      child: (postDetail) {
        print('post: $postDetail');
        return Scaffold(
          appBar: CustomAppBar(
            title: postDetail!.post.supplier!.name,
            actions: [
              FollowButton(supplier: postDetail.post.supplier!),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(postDetail.post.title,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.darkText,
                    )),
                SizedBox(height: 8),
                // Text(postDetail.post.content ?? '',
                //     style: TextStyle(
                //       fontSize: 13,
                //       color: AppColors.darkText,
                //       fontWeight: FontWeight.w300,
                //     )),
              ],
            ),
          ),
        );
      },
    );
  }
}
