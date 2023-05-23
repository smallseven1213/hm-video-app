import 'package:app_gs/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/notice_api.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/ad_banner.dart';
import 'package:shared/widgets/sid_image.dart';
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

  // call notice api and show notice dialog
  showNoticeDialog() async {
    logger.i('===DISPLAY NOTICE DIALOG===');
    Notice? notice = await noticeApi.getBounceOne();
    if (notice != null && mounted) {
      showDialog(
        context: context,
        builder: (BuildContext _ctx) {
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
                                physics: const ClampingScrollPhysics(),
                                child: HtmlWidget(
                                  notice.content ?? '',
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
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
                                        type: 'secondary',
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (notice.leftButtonUrl != '-1' &&
                                              (notice.leftButtonUrl!
                                                      .startsWith('http://') ||
                                                  notice.leftButtonUrl!
                                                      .startsWith(
                                                          'https://'))) {
                                            launch(notice.leftButtonUrl!,
                                                webOnlyWindowName: '_blank');
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox(),

                              notice.rightButton != null
                                  ? SizedBox(
                                      width: 105,
                                      child: Button(
                                        text: notice.rightButton ?? '確認',
                                        type: 'primary',
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (notice.rightButtonUrl != '-1' &&
                                              (notice.rightButtonUrl!
                                                      .startsWith('http://') ||
                                                  notice.rightButtonUrl!
                                                      .startsWith(
                                                          'https://'))) {
                                            launch(notice.rightButtonUrl!,
                                                webOnlyWindowName: '_blank');
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                              // rightButton ?? const SizedBox()
                              // if (leftButton != null)

                              //   Expanded(
                              //     flex: 1,
                              //     child: leftButton ?? const SizedBox(),
                              //   ),
                              // const SizedBox(width: 24),
                              // if (rightButton != null)
                              //   Expanded(
                              //     flex: 1,
                              //     child: rightButton ?? const SizedBox(),
                              //   ),
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
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    List<BannerPhoto>? banners =
        bannerController.banners[BannerPosition.lobbyPopup];
    if (banners!.isEmpty || banners.length < index) {
      return;
    }
    BannerPhoto banner = banners[index];
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_ctx) {
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AdBanner(image: banner, fit: BoxFit.contain),
                      ),
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
