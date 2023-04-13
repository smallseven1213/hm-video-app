import 'package:app_gp/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shared/apis/notice_api.dart';
import 'package:shared/models/index.dart';

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
    print('NoticeDialogState initState');
    super.initState();
    showNoticeDialog();
  }

  // call notice api and show notice dialog
  showNoticeDialog() async {
    Notice? notice = await noticeApi.getBounceOne();
    if (notice != null && mounted) {
      showDialog(
        context: context,
        builder: (BuildContext _ctx) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.zero,
            content: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width / 4 * 3,
                padding: const EdgeInsets.all(20),
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
                    image: AssetImage('assets/images/notice-header.png'),
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
                          top: 5,
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
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                        bottom: 0,
                      ),
                      height: 150,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: HtmlWidget(
                          notice.content ?? '',
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (notice.leftButton != null)
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: double.infinity - 10,
                              child: Button(
                                text: notice.leftButton ?? '取消',
                                type: 'secondary',
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (notice.leftButtonUrl != '-1') {
                                    // todo: 另開新視窗到廣告頁面
                                    // MyRouteDelegate.of(context)
                                    //     .pushAndRemoveUntil(
                                    //         notice.rightButtonUrl ?? '');
                                  }
                                },
                              ),
                            ),
                          ),
                        const SizedBox(width: 20),
                        if (notice.rightButton != null)
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: double.infinity - 10,
                              child: Button(
                                text: notice.rightButton ?? '確認',
                                type: 'primary',
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (notice.rightButtonUrl != '-1') {
                                    // todo: 另開新視窗到廣告頁面
                                    // MyRouteDelegate.of(context)
                                    //     .pushAndRemoveUntil(
                                    //         notice.rightButtonUrl ?? '');
                                  }
                                },
                              ),
                            ),
                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
