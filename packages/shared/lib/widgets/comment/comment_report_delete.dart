import 'package:flutter/material.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/controllers/comment_controller.dart';

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
  String reportTitle = '';
  int reportType = 0;
  int reportLength = 0;
  bool isTypeSelection = true;
  int selectedIndex = 0;
  late CommentController commentReportDeleteController;
  String title = '';
  bool isReport = true;
  String reason = '';

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
    initReport();
    super.initState();
  }

  //舉報初始化
  void initReport() {
    reportType = 0;
    isTypeSelection = true;
    reportTitle = 'please_select_type';
    reportLength = commentReportDeleteController.reportList.length;
  }

  //完成舉報類型選擇後
  void completeTypeSelection(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = 0;
        reportType = index;
        isTypeSelection = false;
        reportTitle = 'please_select_a_reason';
        reportLength =
            commentReportDeleteController.reportList[index].options.length;
      });
    }
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
                                margin: const EdgeInsets.symmetric(vertical: 8),
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
                                      if (isTypeSelection) {
                                        Navigator.pop(context);
                                      } else {
                                        initReport();
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_back_ios_new),
                                    iconSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    localizations.translate(reportTitle),
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
                              child: ListView.builder(
                                itemCount: reportLength,
                                itemBuilder: (context, index) {
                                  if (isTypeSelection) {
                                    return InkWell(
                                      onTap: () {
                                        print('$mounted --------dff----');
                                        completeTypeSelection(index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade200
                                                  .withOpacity(0.5),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 13, 16, 13),
                                          child: Stack(
                                            children: [
                                              Text(
                                                commentReportDeleteController
                                                    .reportList[index].title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
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
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200
                                                .withOpacity(0.5),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: const Color(0xFF6166DC),
                                        value: index,
                                        groupValue: selectedIndex,
                                        onChanged: (int? value) {
                                          setState(() {
                                            selectedIndex = value!;
                                            reason =
                                                commentReportDeleteController
                                                    .reportList[reportType]
                                                    .options[index];
                                          });
                                        },
                                        title: Text(
                                          //取得舉報的類型再取得內容
                                          commentReportDeleteController
                                              .reportList[reportType]
                                              .options[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (!isTypeSelection) ...[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6166DC),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  minimumSize: const Size(double.infinity, 55),
                                ),
                                onPressed: () {
                                  commentReportDeleteController.commentReport(
                                    widget.id,
                                    reportType,
                                    reason,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  localizations.translate('i_want_to_report'),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: double.infinity,
                                height: 50,
                              )
                            ]
                          ],
                        ),
                      );
                    });
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
