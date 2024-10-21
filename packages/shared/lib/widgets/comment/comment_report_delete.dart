import 'package:flutter/material.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/controllers/comment_controller.dart';

class CommentReportDelete extends StatelessWidget {
  final int id;
  final int uid;
  final int topicId;
  final int index;
  CommentReportDelete({
    Key? key,
    required this.id,
    required this.uid,
    required this.topicId,
    required this.index,
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
          commentReportDeleteController.initReport();
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
                  if (commentReportDeleteController.isReport.value) {
                    Navigator.pop(context);
                    // 處理舉報邏輯
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF333344),
                        builder: (BuildContext context) {
                          return Obx(() {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              height: 350,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 4,
                                      width: 40,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          onPressed: () {
                                            if (commentReportDeleteController
                                                .isTypeSelection.value) {
                                              Navigator.pop(context);
                                            } else {
                                              commentReportDeleteController
                                                  .initReport();
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.arrow_back_ios_new),
                                          iconSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          localizations.translate(
                                              commentReportDeleteController
                                                  .reportTitle.value),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Obx(() {
                                      return ListView.builder(
                                        itemCount: commentReportDeleteController
                                            .reportLength.value,
                                        itemBuilder: (context, index) {
                                          if (commentReportDeleteController
                                              .isTypeSelection.value) {
                                            return InkWell(
                                              onTap: () {
                                                commentReportDeleteController
                                                    .completeTypeSelection(
                                                        index);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200
                                                          .withOpacity(0.5),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 13, 16, 13),
                                                  child: Stack(
                                                    children: [
                                                      Text(
                                                        commentReportDeleteController
                                                            .reportList[index]
                                                            .title,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Obx(() {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200
                                                          .withOpacity(0.5),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: RadioListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  activeColor:
                                                      const Color(0xFF6166DC),
                                                  value: index,
                                                  groupValue:
                                                      commentReportDeleteController
                                                          .selectedIndex.value,
                                                  onChanged: (int? value) {
                                                    commentReportDeleteController
                                                        .selectedReportIndex(
                                                            value!);
                                                  },
                                                  title: Text(
                                                    //取得舉報的類型再取得內容
                                                    commentReportDeleteController
                                                        .reportList[
                                                            commentReportDeleteController
                                                                .reportType
                                                                .value]
                                                        .options[index],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() {
                                    if (!commentReportDeleteController
                                        .isTypeSelection.value) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF6166DC),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          minimumSize:
                                              const Size(double.infinity, 55),
                                        ),
                                        onPressed: () {
                                          commentReportDeleteController
                                              .commentReport(id);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          localizations
                                              .translate('i_want_to_report'),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        width: double.infinity,
                                        height: 50,
                                      );
                                    }
                                  }),
                                ],
                              ),
                            );
                          });
                        });
                  } else {
                    //刪除功能
                    commentReportDeleteController.commentDelete(id, index);
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
      },
    );
  }
}
