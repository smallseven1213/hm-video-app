import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart'; // Import GetX package
import 'package:shared/controllers/comment_controller.dart'; // Import your CommentController
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/models/post_detail.dart';
import 'package:shared/modules/post/post_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/comment/input.dart';
import 'package:shared/widgets/comment/list.dart';
import 'package:shared/widgets/posts/follow_button.dart';
import 'package:shared/widgets/posts/post_stats.dart';
import 'package:shared/widgets/posts/tags.dart';
import 'package:shared/widgets/posts/serial_list.dart';
import 'package:shared/widgets/posts/recommend_list.dart';
import 'package:shared/widgets/posts/file_list.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';
import 'package:shared/widgets/comment/comment_section_base.dart';

import '../screens/nodata/index.dart';
import '../utils/show_confirm_dialog.dart';
import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';

// Define color configurations
class AppColors {
  static const contentText = Colors.white;
  static const darkText = Color(0xff919bb3);
}

class PostPage extends StatefulWidget {
  final int id;
  final bool? isDarkMode;

  const PostPage({
    Key? key,
    required this.id,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends CommentSectionBase<PostPage> {
  @override
  int get topicId => widget.id;

  @override
  int get topicType => TopicType.post.index;

  @override
  bool get autoScrollOnFocus => true;

  @override
  Widget build(BuildContext context) {
    return PostConsumer(
      id: widget.id,
      child: (PostDetail? postDetail, {bool? isError}) {
        if (postDetail == null || isError == true) {
          return const NoDataScreen();
        }
        return Scaffold(
          key: Key(
              'postDetail-${postDetail.post.id}-${postDetail.post.isUnlock}'),
          appBar: CustomAppBar(
            titleWidget: InkWell(
              onTap: () {
                MyRouteDelegate.of(context).push(
                  AppRoutes.supplier,
                  args: {'id': postDetail.post.supplier!.id},
                  removeSamePath: true,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarWidget(
                    height: 30,
                    width: 30,
                    photoSid: postDetail.post.supplier!.photoSid,
                    backgroundColor: const Color(0xFFFFFFFF),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    postDetail.post.supplier!.aliasName ?? '',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
                child: FollowButton(supplier: postDetail.post.supplier!),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: UIBottomSafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postDetail.post.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.contentText,
                          ),
                        ),
                        PostStatsWidget(
                          viewCount: postDetail.post.viewCount ?? 0,
                          likeCount: postDetail.post.likeCount ?? 0,
                          postId: postDetail.post.id,
                        ),
                        HtmlWidget(
                          postDetail.post.content ?? '',
                          textStyle: const TextStyle(
                            fontSize: 13,
                            color: AppColors.contentText,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TagsWidget(
                          tags: postDetail.post.tags,
                        ),
                        const SizedBox(height: 8),
                        // Photos or Videos
                        FileListWidget(
                          context: context,
                          postDetail: postDetail.post,
                          showConfirmDialog: showConfirmDialog,
                          buttonBuilder: buttonBuilder,
                        ),
                        // Serial list component
                        SerialListWidget(
                          series: postDetail.series,
                          totalChapter: postDetail.post.totalChapter ?? 0,
                        ),
                        RecommendWidget(recommendations: postDetail.recommend),
                        buildCommentList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: buildCommentInput(),
        );
      },
    );
  }
}
