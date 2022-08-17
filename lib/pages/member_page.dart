import 'package:badges/badges.dart';
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan/scan.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../providers/envent_provider.dart';
import '../shard.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String avatarSid = '';
  final ImagePicker _picker = ImagePicker();

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    Get.find<EventProvider>().putLatest();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showPhotoPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            // width: 200,
            height: 260,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 5,
                  margin: const EdgeInsets.only(
                    top: 8,
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      var sid =
                          await Get.find<PhotoProvider>().uploadPhoto(image);
                      setState(() {
                        avatarSid = sid;
                        // print(avatarSid);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text('相簿選擇'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      var sid =
                          await Get.find<PhotoProvider>().uploadPhoto(image);
                      setState(() {
                        avatarSid = sid;
                        // print(avatarSid);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text('拍照'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color7,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text('取消'),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showQrCodeLoginPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            // width: 200,
            height: 260,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 5,
                  margin: const EdgeInsets.only(
                    top: 8,
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      String? str = await Scan.parse(image.path);
                      if (str != null) {
                        String authToken =
                            await Get.find<AuthProvider>().loginByCode(str);
                        AppController app = Get.find<AppController>();
                        if ("" == authToken) {
                          await alertModal(title: '提示', content: '登入失敗，用戶不存在。');
                          return;
                        } else {
                          await alertModal(title: '成功提示', content: '登入成功');
                        }
                        app.login(authToken);
                        setState(() {});
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text('相簿選擇'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    ScanController controller = ScanController();
                    String qrcode = 'Unknown';
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Container(
                        width: 250, // custom wrap size
                        height: 250,
                        child: ScanView(
                          controller: controller,
                          scanAreaScale: .7,
                          scanLineColor: Colors.green.shade400,
                          onCapture: (str) async {
                            String authToken =
                                await Get.find<AuthProvider>().loginByCode(str);
                            AppController app = Get.find<AppController>();
                            if ("" == authToken) {
                              await alertModal(
                                  title: '提示', content: '登入失敗，用戶不存在。');
                              return;
                            } else {
                              await alertModal(title: '成功提示', content: '登入成功');
                            }
                            app.login(authToken);
                            setState(() {});
                          },
                        ),
                      );
                    }));

                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (_) {
                    //       return new ScanPage();
                    //     }));
                    // XFile? image =
                    //     await _picker.pickImage(source: ImageSource.camera);
                    // if (image != null) {
                    //   var sid =
                    //       await Get.find<PhotoProvider>().uploadPhoto(image);
                    //   setState(() {
                    //     avatarSid = sid;
                    //     // print(avatarSid);
                    //   });
                    // }
                    // Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text('拍照'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color7,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Text('取消'),
                  ),
                ),
              ],
            ),
          );
        });
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

  Future<void> showIdentityCard(BuildContext context, User user) async {
    AppController app = Get.find<AppController>();
    var userCode = await Get.find<AuthProvider>().getLoginCode(app.token);
    var container = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 128,
          child: Container(
            width: gs().width - 40,
            decoration: const BoxDecoration(
              // color: Colors.blue,
              image: DecorationImage(
                image: AssetImage('assets/img/id_card/share-top.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: gs().width - 40,
            decoration: const BoxDecoration(
              // color: Colors.green,
              image: DecorationImage(
                image: AssetImage('assets/img/id_card/share-center.png'),
                repeat: ImageRepeat.repeatY,
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      '用於找回帳號，請妥善保存，請勿洩露',
                      style: TextStyle(fontSize: 12, color: color6),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('ID: ${user.uid}'),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                QrImage(
                  data: userCode,
                  size: 100,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  // height: 28,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    left: 62,
                    right: 62,
                  ),
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color22,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: const Text(
                    '官網地址：www.stt.bet',
                    style: TextStyle(
                      color: color21,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: Container(
            width: gs().width - 40,
            decoration: const BoxDecoration(
              // color: Colors.red,
              image: DecorationImage(
                image: AssetImage('assets/img/id_card/share-bottom.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: SizedBox(
                width: gs().width - 40,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        // const SizedBox(
                        //   height: 34,
                        // ),
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
                                    'stt_id',
                                    img!,
                                    'png',
                                    MimeType.PNG,
                                  );
                                }
                              }
                            } else {
                              await FileSaver.instance.saveFile(
                                'stt_id',
                                img!,
                                'png',
                                mimeType: MimeType.PNG,
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .15),
                                  offset: Offset(0, 2),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: const Text(
                              '請截圖保存',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
    return showDialog(
        context: context,
        builder: (_ctx) {
          return Screenshot(
            controller: screenshotController,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              titlePadding: EdgeInsets.zero,
              title: null,
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                height: 500,
                child: container,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          backgroundColor: mainBgColor,
          shadowColor: Colors.transparent,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: mainBgColor,
          ),
        ),
        body: FutureBuilder<User>(
          future: Get.find<UserProvider>().getCurrentUser(),
          builder: (_ctx, _snapshot) {
            var user = _snapshot.data ?? User('', 0, ['guest']);
            return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: color1,
                      toolbarHeight: 0,
                      collapsedHeight: 180 - 8,
                      expandedHeight: 180 - 8,
                      pinned: true,
                      flexibleSpace: Stack(
                        children: [
                          Container(
                            width: gs().width,
                            height: 180 - 8,
                            decoration: const BoxDecoration(
                              color: color1,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 25,
                                  right: 15,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          gto('/member/messages');
                                        },
                                        child: FutureBuilder(
                                            future: SharedPreferencesUtil
                                                .hasEventLatest(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<bool> snapshot) {
                                              if (snapshot.hasData) {
                                                bool? hasEvent = snapshot.data;
                                                if (hasEvent!) {
                                                  return Badge(
                                                    shape: BadgeShape.circle,
                                                    position:
                                                        BadgePosition.topEnd(
                                                            top: -1, end: -2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: const VDIcon(
                                                        VIcons.mail),
                                                    badgeContent: Container(
                                                      height: 0.1,
                                                      width: 0.1,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  );
                                                }
                                              }
                                              return VDIcon(VIcons.mail);
                                            })),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (user.isGuest()) {
                                          gto('/member/upgrade');
                                        } else {
                                          gto('/member/settings');
                                        }
                                      },
                                      child: const VDIcon(VIcons.setting),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  left: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // if (!user.isGuest()) {
                                        showPhotoPicker(context);
                                        // }
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          FutureBuilder<String>(
                                            future: AuthProvider.getToken(),
                                            builder: (_cctx, _ssnap) => (!_ssnap
                                                        .hasData ||
                                                    (user.avatar == null ||
                                                        user.avatar?.isEmpty ==
                                                            true))
                                                ? const CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: AssetImage(
                                                        'assets/img/icon-supplier@3x.png'),
                                                  )
                                                : ClipOval(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: SizedBox(
                                                      width: 60,
                                                      height: 60,
                                                      child: VDImage(
                                                        url: user.avatar ?? '',
                                                        // width: 60,
                                                        // height: 60,
                                                        headers: {
                                                          'Authorization':
                                                              _ssnap.data ?? '',
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          Positioned(
                                              right: 2,
                                              bottom: 2,
                                              child: CircleAvatar(
                                                maxRadius: 7,
                                                minRadius: 7,
                                                backgroundColor: color1,
                                                child: SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child: VDIcon(
                                                    VIcons.add2,
                                                    height: 14,
                                                    width: 14,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        user.isGuest()
                                            ? Text(
                                                '訪客${user.isGuest() ? user.uid : ''}',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              )
                                            : user.isVip()
                                                ? Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/png/vip.png',
                                                        width: 34,
                                                        height: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(user.nickname ?? ''),
                                                      InkWell(
                                                        onTap: () {
                                                          gto('/member/setting/nickname');
                                                        },
                                                        child: const VDIcon(
                                                            VIcons.edit),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(user.nickname ?? ''),
                                                      InkWell(
                                                        onTap: () {
                                                          gto('/member/setting/nickname');
                                                        },
                                                        child: const VDIcon(
                                                            VIcons.edit),
                                                      ),
                                                    ],
                                                  ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'ID: ${user.uid}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                  bottom: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 32,
                                        padding: const EdgeInsets.only(
                                          top: 9,
                                          bottom: 4,
                                          left: 20,
                                          right: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color3,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Text(NumberFormat.currency(
                                                symbol: '\$  ')
                                            .format(DecimalIntl(Decimal.parse(
                                                user.points ?? '0')))),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        gto('/member/wallet')?.then((v) {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 8,
                                          right: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color3,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: const VDIcon(
                                          VIcons.reload_black,
                                          height: 14,
                                          width: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Container(
                    color: color1,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    // spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: Offset(3, -3),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            children: const [
                                              Text(
                                                '0',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                '粉絲',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const VerticalDivider(
                                            // width: 10,
                                            thickness: 1,
                                            indent: 12,
                                            endIndent: 13,
                                            color: color6,
                                          ),
                                          Column(
                                            children: const [
                                              Text(
                                                '0',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                '關注',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const VerticalDivider(
                                            // width: 10,
                                            thickness: 1,
                                            indent: 12,
                                            endIndent: 13,
                                            color: color6,
                                          ),
                                          Column(
                                            children: const [
                                              Text(
                                                '0',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                '獲讚',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: gs().width - 40,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/img-vip@3x.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // if (user.isVip()) {} else {}
                                              gto('/member/vip');
                                            },
                                            child: Container(
                                              width: gs().width - 81,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const VDIcon(
                                                            VIcons.diamond),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Stack(
                                                          children: [
                                                            Text(
                                                              user.isVip()
                                                                  ? 'VIP用戶：至${DateFormat('yyyy/MM/dd').format(DateTime.parse(user.vipExpiredAt ?? '2011/01/01'))}'
                                                                  : '開通VIP無限看片',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        bottom: 5,
                                                        left: 15,
                                                        right: 15,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32.0),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      child: Text(
                                                        user.isVip()
                                                            ? '續訂'
                                                            : '查看詳情',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '推薦服務',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Wrap(
                                      spacing: 5,
                                      children: ([
                                        DataService(
                                            VIcons.recommend_wallet, '金幣錢包',
                                            onTap: () {
                                          gto('/member/wallet')?.then((v) {
                                            setState(() {});
                                          });
                                        }),
                                        DataService(
                                            VIcons.recommend_purchasehistory,
                                            '購買記錄', onTap: () {
                                          gto('/member/record/purchase');
                                        }),
                                        DataService(
                                            VIcons.recommend_viewhistory,
                                            '播放紀錄', onTap: () {
                                          gto('/member/record/history');
                                        }),
                                        DataService(
                                            VIcons.recommend_like, '我的喜歡',
                                            onTap: () {
                                          gto('/member/record/favorite');
                                        }),
                                        DataService(
                                            VIcons.recommend_i_dcasrd, '身份卡',
                                            onTap: () {
                                          showIdentityCard(context, user);
                                        }),

                                        DataService(
                                            VIcons.promote_shard, '推廣分享',
                                            onTap: () {
                                          if (user.isGuest()) {
                                            alertModal(
                                                title: "提示", content: "請先註冊。");
                                          } else {
                                            gto('/member/share');
                                          }
                                        }),
                                        DataService(
                                            VIcons.promote_recore, '推廣紀錄',
                                            onTap: () {
                                          if (user.isGuest()) {
                                            alertModal(
                                                title: "提示", content: "請先註冊。");
                                          } else {
                                            gto('/member/share/history');
                                          }
                                        }),
                                        // DataService(VIcons.recommend_share, '推廣分享', onTap: () {
                                        //   // gto('/member/share');
                                        // }),
                                        // DataService(VIcons.recommend_sharehistory, '推廣紀錄',
                                        //     onTap: () {
                                        //   // gto('/member/share/history');
                                        // }),
                                        // DataService(VIcons.recommend_creator, '創作中心'),
                                      ])
                                          .map(
                                            (e) => Container(
                                              width: (gs().width - 55) / 4,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                              ),
                                              child: InkWell(
                                                onTap: e.onTap ?? () {},
                                                child: Column(
                                                  children: [
                                                    VDIcon(e.icon),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      e.title,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    const Divider(
                                      color: color7,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '更多服務',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      children: [
                                        DataService(VIcons.ticket, '序號兌換',
                                            onTap: () async {
                                          // await alertModal(
                                          //     title: '提示', content: '敬請期待');
                                          gto('/member/ticket');
                                        }),
                                        DataService(
                                            VIcons.backupaccount, '找回帳號',
                                            onTap: () async {
                                          if (kIsWeb) {
                                            await alertModal(
                                                title: '提示',
                                                content: '請使用手機應用程式找回帳號。');
                                            return;
                                          } else {
                                            showQrCodeLoginPicker(context);
                                          }
                                        }),
                                        DataService(VIcons.application, '應用中心',
                                            onTap: () {
                                          gto('/member/ads1');
                                        }),
                                        DataService(VIcons.cs, '在線客服',
                                            onTap: () {
                                          launch(
                                              '${AppController.cc.endpoint.getApi()}/public/domains/domain/customer-services');
                                        }),
                                        DataService(VIcons.chat_black, '官方聊天群'),
                                        DataService(VIcons.download,
                                            '版本號：${AppController.cc.version}${kIsWeb ? '' : '_a'}'),
                                        // DataService(VIcons.download, '下載'),
                                      ]
                                          .map((e) => [
                                                InkWell(
                                                  onTap: e.onTap ?? () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 8,
                                                      bottom: 8,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        VDIcon(e.icon),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            e.title,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ),
                                                        const VDIcon(VIcons
                                                            .arrow_2_right),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  color: color7,
                                                  thickness: 1,
                                                ),
                                              ])
                                          .reduce((value, element) => [
                                                ...value,
                                                ...element,
                                              ])
                                          .toList(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )));
          },
        ),
        // bottomNavigationBar: VDBottomNavigationBar(
        //   collection: Get.find<VBaseMenuCollection>(),
        //   activeIndex: Get.find<AppController>().navigationBarIndex,
        //   onTap: Get.find<AppController>().toNamed,
        // ),
      ),
    );
  }
}
