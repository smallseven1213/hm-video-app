import 'package:app_gs/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/notice_api.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/ad_banner.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

class NoticeDialog extends StatefulWidget {
  const NoticeDialog({super.key});

  @override
  State<NoticeDialog> createState() => NoticeDialogState();
}

class NoticeDialogState extends State<NoticeDialog> {
  NoticeApi noticeApi = NoticeApi();
  BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(BannerPosition.lobbyPopup);
    showNoticeDialog();
  }

  void handleUrl(String? url, BuildContext context) {
    Navigator.pop(context);
    if (url != null && url != '-1') {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        // Launch external URL
        launch(url, webOnlyWindowName: '_blank');
      } else {
        // Navigate to internal route
        List<String> parts = url.split('/');

        // 從列表中獲取所需的字串和數字
        String path = '/${parts[1]}';
        int id = int.parse(parts[2]);

        // 創建一個 Object，包含 id
        var args = {'id': id};

        MyRouteDelegate.of(context).push(path, args: args);
      }
    }
  }

  // call notice api and show notice dialog
  showNoticeDialog() async {
    logger.i('===DISPLAY NOTICE DIALOG===');
    Notice? notice = await noticeApi.getBounceOne();
    if (notice != null && mounted) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            content: Container(
                width: 270,
                height: 320,
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 95,
                        left: 25,
                        right: 25,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              notice.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              height: 132,
                              child: SingleChildScrollView(
                                physics: kIsWeb
                                    ? null
                                    : const ClampingScrollPhysics(),
                                child: HtmlWidget(
                                  notice.content ?? '',
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onTapUrl: (url) => launchUrl(Uri.parse(url)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              notice.leftButton != null
                                  ? SizedBox(
                                      width: 105,
                                      child: Button(
                                        text: notice.leftButton ?? '取消',
                                        type: 'cancel',
                                        onPressed: () => handleUrl(
                                            notice.leftButtonUrl, context),
                                      ),
                                    )
                                  : const SizedBox(),
                              notice.rightButton != null
                                  ? Container(
                                      width: 105,
                                      decoration: kIsWeb
                                          ? null
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF00b2ff),
                                                  width: 1),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                            ),
                                      child: Button(
                                        text: notice.rightButton ?? '確認',
                                        type: 'primary',
                                        onPressed: () => handleUrl(
                                            notice.rightButtonUrl, context),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      ).then((value) {
        showAdDialog(0);
      });
    }
  }

  showAdDialog(int index) {
    MediaQuery.of(context).size.width * 0.8;
    List<BannerPhoto>? banners =
        bannerController.banners[BannerPosition.lobbyPopup];
    if (banners!.isEmpty || banners.length < index) {
      return;
    }
    BannerPhoto banner = banners[index];
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.zero,
            title: null,
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: AspectRatio(
                      aspectRatio: 9 / 12,
                      child: AdBanner(image: banner, fit: BoxFit.contain),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 2),
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      child: Icon(
                        Icons.close,
                        weight: 5,
                        color: Colors.white.withOpacity(0.5),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
      if (banners.length > index + 1) {
        showAdDialog(1 + index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
