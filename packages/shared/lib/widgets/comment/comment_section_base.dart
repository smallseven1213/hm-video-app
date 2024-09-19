import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/comment_controller.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/widgets/comment/input.dart';
import 'package:shared/widgets/comment/list.dart';

abstract class CommentSectionBase<T extends StatefulWidget> extends State<T> {
  late CommentController _commentController;
  late ScrollController _scrollController;
  bool _isKeyboardVisible = false;

  // 子類別需實現這些抽象方法
  int get topicId;
  int get topicType;

  @override
  void initState() {
    super.initState();
    // 初始化 CommentController
    _commentController = Get.put(
      CommentController(
        topicId: topicId,
        topicType: topicType,
      ),
      tag: 'comment-$topicId',
    );
    _scrollController = ScrollController(); // 初始化 ScrollController
  }

  @override
  void dispose() {
    // 銷毀 CommentController 和 ScrollController
    if (Get.isRegistered<CommentController>(tag: 'comment-$topicId')) {
      Get.delete<CommentController>(tag: 'comment-$topicId');
    }
    _scrollController.dispose();
    super.dispose();
  }

  // 返回 CommentList 小部件
  Widget buildCommentList() {
    return CommentList(
      topicId: topicId,
      topicType: TopicType.values[topicType],
    );
  }

  // 返回 CommentInput 小部件，包含發送評論的邏輯
  Widget buildCommentInput() {
    return CommentInput(
      onSend: (String text) async {
        await _commentController.createComment(text);
        // 等待 UI 更新，然後滾動到最新的評論
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      },
      onFocusChange: (bool hasFocus) {
        setState(() {
          _isKeyboardVisible = hasFocus;
        });
      },
    );
  }

  // 滾動邏輯，可選擇性附加到滾動部件上
  ScrollController get scrollController => _scrollController;
}
