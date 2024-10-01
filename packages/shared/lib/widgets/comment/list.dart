import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:shared/controllers/comment_controller.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/widgets/avatar.dart';

class CommentList extends StatefulWidget {
  final int topicId;
  final TopicType topicType;
  final bool showNoMoreComments;
  final ScrollController? scrollController;

  const CommentList({
    required this.topicId,
    required this.topicType,
    this.showNoMoreComments = false,
    this.scrollController,
  });

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  late ScrollController _scrollController;
  late CommentController _commentController;
  final ValueNotifier<int?> _expandedCommentId = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    _commentController =
        Get.find<CommentController>(tag: 'comment-${widget.topicId}');
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // 当滚动到距离底部100像素以内时，加载更多评论
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_commentController.isLoading.value &&
          _commentController.hasMoreData) {
        _commentController.loadMoreComments();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _expandedCommentId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return Obx(() {
      int itemCount =
          _commentController.comments.length + 1; // +1 for the header
      bool showExtraItem = _commentController.isLoading.value ||
          (!_commentController.hasMoreData && widget.showNoMoreComments);

      if (showExtraItem) {
        itemCount +=
            1; // Add extra item for loading indicator or "no more comments" message
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Return the header
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: Text(
                  localizations.translate('comment'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          } else if (index > 0 && index <= _commentController.comments.length) {
            final comment =
                _commentController.comments[index - 1]; // Adjust index
            return CommentItem(
              item: comment,
              expandedCommentId: _expandedCommentId, // 传递共享的 ValueNotifier
            );
          } else {
            // This is the extra item at the end
            if (_commentController.isLoading.value) {
              return const Center(
                  child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ));
            } else if (!_commentController.hasMoreData &&
                widget.showNoMoreComments) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    localizations.translate('nothing_more'),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }
        },
      );
    });
  }
}

class CommentItem extends StatefulWidget {
  final Comment item;
  final ValueNotifier<int?> expandedCommentId; // 添加这个参数

  const CommentItem({
    Key? key,
    required this.item,
    required this.expandedCommentId, // 添加这个参数
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late ValueNotifier<bool> isCollapsed;

  @override
  void initState() {
    super.initState();
    isCollapsed = ValueNotifier<bool>(true);

    // 监听 expandedCommentId 的变化
    widget.expandedCommentId.addListener(_expandedCommentIdListener);

    // 监听 isCollapsed 的变化
    isCollapsed.addListener(_isCollapsedListener);
  }

  void _expandedCommentIdListener() {
    if (widget.expandedCommentId.value == widget.item.id) {
      if (isCollapsed.value) {
        isCollapsed.value = false;
      }
    } else {
      if (!isCollapsed.value) {
        isCollapsed.value = true;
      }
    }
  }

  void _isCollapsedListener() {
    if (!isCollapsed.value) {
      // 展开状态
      if (widget.expandedCommentId.value != widget.item.id) {
        widget.expandedCommentId.value = widget.item.id;
      }
    } else {
      // 收起状态
      if (widget.expandedCommentId.value == widget.item.id) {
        widget.expandedCommentId.value = null;
      }
    }
  }

  @override
  void dispose() {
    widget.expandedCommentId.removeListener(_expandedCommentIdListener);
    isCollapsed.removeListener(_isCollapsedListener);
    isCollapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return ListTile(
      leading: AvatarWidget(
        photoSid: widget.item.avatar,
        width: 36,
        height: 36,
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        widget.item.userName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            widget.item.content,
            trimLines: 5,
            colorClickableText: Colors.grey,
            trimMode: TrimMode.Line,
            trimCollapsedText: localizations.translate('expand'),
            trimExpandedText: localizations.translate('collapse'),
            style: const TextStyle(color: Colors.white, fontSize: 11),
            isCollapsed: isCollapsed,
          ),
        ],
      ),
    );
  }
}
