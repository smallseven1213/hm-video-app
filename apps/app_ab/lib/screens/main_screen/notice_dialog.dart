import 'package:app_ab/config/colors.dart';
import 'package:app_ab/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/notice_api.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/ad_banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared/apis/user_api.dart';

final logger = Logger();

class NoticeDialog extends StatefulWidget {
  const NoticeDialog({super.key});

  @override
  State<NoticeDialog> createState() => NoticeDialogState();
}

class NoticeDialogState extends State<NoticeDialog> {
  UserApi userApi = UserApi();
  NoticeApi noticeApi = NoticeApi();
  BannerController bannerController = Get.find<BannerController>();
  Map? bounceData = {'notice': null, 'banner': null};

  @override
  void initState() {
    super.initState();
    // showNoticeDialog();
  }

  void handleUrl(String? url, BuildContext context) {
    userApi.writeUserEnterHallRecord();
    Navigator.pop(context);
    if (url != null && url != '-1') {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        // Launch external URL
        launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
      } else {
        // Navigate to internal route
        List<String> parts = url.split('/');

        // 从列表中获取所需的字串和数字
        String path = '/${parts[1]}';

        if (parts.length == 3) {
          int id = int.parse(parts[2]);
          var args = {'id': id};
          MyRouteDelegate.of(context).push(path, args: args);
        } else if (path == '/splash') {
          MyRouteDelegate.of(context).push(
            '/',
            args: {'skipNavigation': true},
            removeSamePath: true,
          );
        } else {
          MyRouteDelegate.of(context).push(path);
        }
      }
    }
  }

  // call notice api and show notice dialog
  showNoticeDialog() async {
    logger.i('===DISPLAY NOTICE DIALOG===');
    Map? result = await noticeApi.getBounce();
    Notice? notice = result!['notice'];
    setState(() {
      bounceData = result;
    });
    if (notice != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Image(
              image: AssetImage('assets/images/notice-header.png'),
              height: 95,
              fit: BoxFit.fitWidth,
            ),
            content: SizedBox(
              width: 270,
              height: 310,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colors[ColorKeys.noticeBg],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            notice.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.colors[ColorKeys.textPrimary],
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
                              physics:
                                  kIsWeb ? null : const ClampingScrollPhysics(),
                              child: HtmlWidget(
                                notice.content ?? '',
                                textStyle: TextStyle(
                                  color:
                                      AppColors.colors[ColorKeys.textPrimary],
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
                                ? SizedBox(
                                    width: 105,
                                    child: Button(
                                      text: notice.rightButton ?? '确认',
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
              ),
            ),
          );
        },
      ).then((value) {
        showAdDialog(0);
      });
    }
  }

  showAdDialog(int index) {
    MediaQuery.of(context).size.width * 0.8;
    List<BannerPhoto>? banners = bounceData!['banners'];
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
