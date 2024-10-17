import 'package:flutter/material.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/controllers/comment_controller.dart';

class CommentReportDelete extends StatelessWidget {
  final int id;
  final int uid;
  final int topicId;
  CommentReportDelete({
    Key? key,
    required this.id,
    required this.uid,
    required this.topicId,
  }) : super(key: key);

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    final commentReportDeleteController =
        Get.find<CommentController>(tag: 'comment-$topicId');

    return Obx(
      () {
        if (uid == userController.infoV2.value.uid) {
          commentReportDeleteController.changeTitleToDelete();
        } else {
          commentReportDeleteController.changeTitleToReport();
        }
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
                  // 處理檢舉邏輯
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6166DC), // 按鈕顏色
                  padding: const EdgeInsets.symmetric(vertical: 15), // 增加按鈕高度
                  minimumSize: const Size(double.infinity, 50), // 設定按鈕寬度
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  localizations
                      .translate(commentReportDeleteController.title.value),
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
                  backgroundColor: const Color(0xFF444455), // 按鈕顏色（較深）
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '取消',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
