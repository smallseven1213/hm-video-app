import 'package:flutter/material.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/controllers/comment_controller.dart';
import 'package:shared/widgets/comment/comment_report.dart';

class CommentReportDelete extends StatefulWidget {
  final int id;
  final int uid;
  final int topicId;
  final int index;

  const CommentReportDelete({
    Key? key,
    required this.id,
    required this.uid,
    required this.topicId,
    required this.index,
  }) : super(key: key);

  @override
  CommentReportDeleteState createState() => CommentReportDeleteState();
}

class CommentReportDeleteState extends State<CommentReportDelete> {
  final userController = Get.find<UserController>();
  late CommentController commentReportDeleteController;
  String title = '';
  bool isReport = true;

  @override
  void initState() {
    commentReportDeleteController =
        Get.find<CommentController>(tag: 'comment-${widget.topicId}');
    if (widget.uid == userController.infoV2.value.uid) {
      title = 'delete_comment';
      isReport = false;
    } else {
      title = 'i_want_to_report';
      isReport = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (isReport) {
                Navigator.pop(context);
                // 處理舉報邏輯
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF333344),
                  builder: (BuildContext context) {
                    return CommentReport(
                      id: widget.id,
                      topicId: widget.topicId,
                    );
                  },
                );
              } else {
                //刪除功能
                commentReportDeleteController.commentDelete(
                    widget.id, widget.index);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6166DC),
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              localizations.translate(title),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF444455),
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              localizations.translate('cancel'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
