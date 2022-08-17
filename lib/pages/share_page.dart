import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/user_provider.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../models/user_promote.dart';

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  ScreenshotController screenshotController = ScreenshotController();
  String inviteCode = 'ABC123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: color1,
        shadowColor: Colors.transparent,
        toolbarHeight: 48,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: color1,
        ),
        leading: InkWell(
          onTap: () {
            back();
          },
          enableFeedback: true,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
        ),
        title: Stack(
          children: [
            Transform(
              transform: Matrix4.translationValues(-26, 0, 0),
              child: const Center(
                child: Text(
                  '推廣分享',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(0, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:  [
                InkWell(
                  onTap: () {
                    gto('/member/share/history');
                  },
                  child: const Text(
                    '推廣紀錄',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),)
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Get.find<UserProvider>().getUserPromote(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container(
                color: Colors.transparent,
              );
            }
            UserPromote userPromote = snapshot.data;
            String promotedMembers = userPromote.promotedMembers.toString();
            String changed = userPromote.changed.toString();
            String invitationCode = userPromote.invitationCode;
            String promoteLink = userPromote.promoteLink;
            return Container(
              color: color1,
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    // height: gs().height,
                    padding: const EdgeInsets.only(bottom: 60),
                    decoration: const BoxDecoration(
                      color: color1,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: gs().width,
                          height: gs().width / 2.14,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/img/group-2-rectangle-group-group-3-path-path-mask-copy@3x.png'),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 36,
                            right: 36,
                            bottom: 36,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 12),
                                  blurRadius: 12,
                                  spreadRadius: -4,
                                  color: Color.fromRGBO(73, 54, 7, .2),
                                ),
                              ],
                              color: color3,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                                bottom: 16,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Color.fromRGBO(0, 0, 0, .1),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 19,
                                              ),
                                              child: Column(
                                                children:  [
                                                  Text(
                                                    "$promotedMembers人",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  const Text(
                                                    '已推廣',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: color4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            thickness: 1,
                                            indent: 27,
                                            endIndent: 27,
                                            color: color23,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 19,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "$changed天",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  const Text(
                                                    '已獲得免費看',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: color4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      indent: 16,
                                      endIndent: 16,
                                      color: color7,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                      ),
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color22,
                                        borderRadius: BorderRadius.circular(14.0),
                                      ),
                                      child: Text(
                                        '邀請碼：$invitationCode',
                                        style: TextStyle(
                                          color: color21,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    QrImage(
                                      data: "https://" + promoteLink,
                                      size: 150,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Clipboard.setData(ClipboardData(text: "https://" + promoteLink));
                                        await alertModal(
                                            title: '提示', content: '複製成功。');
                                      },
                                      child: Container(
                                        width: gs().width - 152,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color1,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child:  const Text(
                                          '複製分享連結',
                                          style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        var img = await screenshotController.capture(
                                            delay: const Duration(milliseconds: 10));
                                        if (!kIsWeb) {
                                          if (isAndroid()) {
                                            bool status =
                                            await Permission.storage.isGranted;
                                            if (!status) {
                                              await Permission.storage.request();
                                            }
                                            if (status) {
                                              await FileSaver.instance.saveAs(
                                                'stt_share',
                                                img!,
                                                'png',
                                                MimeType.PNG,
                                              );
                                            }
                                          }
                                        } else {
                                          await FileSaver.instance.saveFile(
                                            'stt_share',
                                            img!,
                                            'png',
                                            mimeType: MimeType.PNG,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: gs().width - 152,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color7,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: const Text(
                                          '截圖分享',
                                          style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            gto("/member/share/tutorial");
                          },
                          child: Container(
                            width: gs().width - 200,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Text(
                              '推廣教學',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            );

        },),
      ),
    );
  }

  Future<void> alertModal({String title = '', String content = ''}) async {
    return showDialog(
      context: context,
      builder: (_ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            padding:
            const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: color1,
                    ),
                    child: const Text('確認'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
