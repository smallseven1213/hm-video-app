import 'package:flutter/material.dart';
import 'package:shared/models/comment.dart';
import 'package:shared/widgets/comment/index.dart';

class AppColors {
  static const contentText = Color(0xff919bb3);
  static const background = Colors.black;
}

class CommentBottomSheet extends StatelessWidget {
  final int postId;
  final bool autoFocusInput;

  const CommentBottomSheet({
    Key? key,
    required this.postId,
    this.autoFocusInput = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Color(0xff0f1320),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Draggable indicator
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: CommentSection(
                topicId: postId,
                topicType: TopicType.post,
                isScrollable: true,
                autoFocusInput: autoFocusInput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
