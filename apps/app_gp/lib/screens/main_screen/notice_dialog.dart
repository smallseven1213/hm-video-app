// import 'package:app_gp/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/notice_api.dart';
import 'package:shared/models/index.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

void alertDialog(
  BuildContext context,
  Notice notice, {
  String? title,
  String? content,
  List<Widget>? actions,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: EdgeInsets.zero,
        content: IntrinsicHeight(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                stops: [0.0, 0.9375, 1.0],
                colors: [
                  Color(0xff000916),
                  Color(0xff003F6C),
                  Color(0xff005B9C)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: DecorationImage(
                image: NetworkImage(
                    'https://pgw.udn.com.tw/gw/photo.php?u=https://uc.udn.com.tw/photo/2022/02/22/0/16107669.jfif&s=Y&x=0&y=0&sw=899&sh=599&exp=3600'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 45,
                      left: 20,
                      right: 20,
                      bottom: 0,
                    ),
                    child: Text(
                      notice.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  child: SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Text(notice.content ?? ''),

                      // HtmlWidget(
                      //   notice.content ?? '',
                      //   textStyle: TextStyle(
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Button(
                    //   text: 'text',
                    //   onPressed: () => Navigator.of(context).pop(),
                    // ),
                    if (notice.leftButton != null) ...[
                      TextButton(
                        child: Text(notice.leftButton ?? ''),
                        onPressed: () {
                          if (notice.leftButtonUrl == '-1') {
                            Navigator.of(context).pop();
                          } else {
                            Get.toNamed(notice.leftButtonUrl ?? '取消');
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                    if (notice.leftButton != null) ...[
                      ElevatedButton(
                        child: Text(notice.rightButton ?? ''),
                        onPressed: () {
                          if (notice.rightButtonUrl == '-1') {
                            Navigator.of(context).pop();
                          } else {
                            Get.toNamed(notice.rightButtonUrl ?? '確認');
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class NoticeDialog extends StatefulWidget {
  const NoticeDialog({super.key});

  @override
  State<NoticeDialog> createState() => NoticeDialogState();
}

class NoticeDialogState extends State<NoticeDialog> {
  NoticeApi noticeApi = NoticeApi();

  @override
  void initState() {
    // 入站公告 /notice/latest/bounce
    super.initState();
    showNoticeDialog();

    // Future.microtask(() async {
    //   try {
    //     Get.defaultDialog(
    //       title: '已有新版本',
    //       content: const Text('已發布新版本，為了更流暢的觀影體驗，請更新版本'),
    //       textConfirm: '立即體驗',
    //       textCancel: '暫不升級',
    //       confirmTextColor: Colors.white,
    //       onConfirm: () {
    //         Get.back();
    //         // TODO: 跳轉到更新頁面
    //         // launch('https://${apkUpdate.url ?? ''}');
    //       },
    //       onCancel: () {
    //         Get.back();
    //       },
    //     );
    //   } catch (e) {
    //     print('error: $e');
    //   }
    // });
    // Get.dialog(
    //   AlertDialog(
    //     title: Text('result.title'),
    //     content: Text('sss'),
    //     actions: [
    //       TextButton(
    //         child: const Text("Close"),
    //         onPressed: () => Get.back(),
    //       ),
    //     ],
    //   ),
    // );
  }

  // call notice api and show notice dialog
  showNoticeDialog() async {
    Notice? notice = await noticeApi.getBounceOne();
    if (notice != null && mounted) {
      print('notice: $notice');
      alertDialog(context, notice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
