import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/controllers/comment_controller.dart';

class CommentReport extends StatefulWidget {
  final int id;
  final int topicId;

  const CommentReport({
    Key? key,
    required this.id,
    required this.topicId,
  }) : super(key: key);

  @override
  CommentReportState createState() => CommentReportState();
}

class CommentReportState extends State<CommentReport> {
  String reportTitle = '';
  int reportType = 0;
  int reportLength = 0;
  bool isTypeSelection = true;
  int selectedIndex = 0;
  late CommentController commentReportDeleteController;
  String reason = '';
  late ScrollController reasonListController;
  late ScrollController typeListController;

  @override
  void initState() {
    super.initState();
    commentReportDeleteController =
        Get.find<CommentController>(tag: 'comment-${widget.topicId}');
    typeListController = ScrollController();
    reasonListController = ScrollController();
    initReport();
  }

  @override
  void dispose() {
    typeListController.dispose();
    reasonListController.dispose();
    super.dispose();
  }

  // 舉報初始化
  void initReport() {
    reportType = 0;
    isTypeSelection = true;
    reportTitle = 'please_select_type';
    reportLength = commentReportDeleteController.reportList.length;
    if (typeListController.hasClients) {
      typeListController.jumpTo(0);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (typeListController.hasClients) {
          typeListController.jumpTo(0);
        }
      });
    }
  }

  // 完成舉報類型選擇後
  void completeTypeSelection(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = 0;
        reportType = index;
        isTypeSelection = false;
        reportTitle = 'please_select_a_reason';
        reportLength =
            commentReportDeleteController.reportList[index].options.length;
        if (reasonListController.hasClients) {
          reasonListController.jumpTo(0);
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (reasonListController.hasClients) {
              reasonListController.jumpTo(0);
            }
          });
        }
        if (reportLength > 0) {
          reason = commentReportDeleteController.reportList[index].options[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 350,
      color: const Color(0xFF333344),
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
          const SizedBox(height: 10),
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (isTypeSelection) {
                      Navigator.pop(context);
                    } else {
                      if (mounted) {
                        setState(() {
                          initReport();
                        });
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  localizations.translate(reportTitle),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            // 彈跳視窗內容切換
            child: isTypeSelection
                ? _buildTypeSelection(context, localizations)
                : _buildReasonSelection(context, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelection(
      BuildContext context, SharedLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            controller: typeListController,
            itemCount: reportLength,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  completeTypeSelection(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200.withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            commentReportDeleteController
                                .reportList[index].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildReasonSelection(
      BuildContext context, SharedLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            controller: reasonListController,
            itemCount: reportLength,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.grey, // 未選中的圓圈顏色
                  ),
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF6166DC),
                    value: index,
                    groupValue: selectedIndex,
                    onChanged: (int? value) {
                      setState(() {
                        selectedIndex = value!;
                        reason = commentReportDeleteController
                            .reportList[reportType].options[index];
                      });
                    },
                    title: Text(
                        commentReportDeleteController
                            .reportList[reportType].options[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        if (reportLength > 0)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6166DC),
            padding: const EdgeInsets.symmetric(vertical: 15),
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
        const SizedBox(height: 5),
      ],
    );
  }
}
