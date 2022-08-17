import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class RadioCliper extends CustomClipper<Path> {
  bool reversed;
  RadioCliper({bool this.reversed = false});
  @override
  Path getClip(Size size) {
    Path path = Path();
    if (reversed) {
      path.moveTo(15, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width - 15, size.height);
      path.lineTo(size.width, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MemberUpgradePage extends StatefulWidget {
  const MemberUpgradePage({Key? key}) : super(key: key);

  @override
  _MemberUpgradePageState createState() => _MemberUpgradePageState();
}

class _MemberUpgradePageState extends State<MemberUpgradePage> {
  int memberType = 1;
  bool registerMode = false;
  String photoCountry = '+86';
  bool isValidated = false;
  bool canSend = false;
  bool isChecked = false;
  bool firstControllerEmpty = true;
  bool secondControllerEmpty = true;
  bool thirdControllerEmpty = true;
  bool forthControllerEmpty = true;
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  final TextEditingController _forthController = TextEditingController();
  String firstError = '';
  String secondError = '';
  String thirdError = '';
  String forthError = '';
  int seconds = 0;
  User? user;

  @override
  void initState() {
    super.initState();
    Get.find<UserProvider>().getCurrentUser().then((value) {
      user = value;
    });
  }

  void changeMemberType(int type) {
    setState(() {
      memberType = type;
      _firstController.clear();
      _secondController.clear();
      _thirdController.clear();
      _forthController.clear();
      firstControllerEmpty = true;
      secondControllerEmpty = true;
      thirdControllerEmpty = true;
      forthControllerEmpty = true;
      canSend = false;
      isChecked = memberType == 2;
      firstError = '';
      secondError = '';
      thirdError = '';
      forthError = '';
      isValidated = false;
    });
  }

  void sendValidatedCode() {
    setState(() {
      canSend = false;
      seconds = 30;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
        setState(() {
          canSend = true;
        });
      } else {
        setState(() {
          seconds--;
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        toolbarHeight: 48,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
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
                  '會員升級',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  decoration: const BoxDecoration(
                    color: color7,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: memberType == 1 ? 7 : 6,
                          child: InkWell(
                            onTap: () {
                              changeMemberType(1);
                            },
                            child: ClipPath(
                              clipper: RadioCliper(),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                  top: 9,
                                  bottom: 9,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                  ),
                                  color: memberType == 1
                                      ? color1
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  '手機號',
                                  style: TextStyle(
                                    color:
                                        memberType == 1 ? Colors.black : color5,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: memberType == 2 ? 7 : 6,
                        child: InkWell(
                          onTap: () {
                            changeMemberType(2);
                          },
                          child: ClipPath(
                            clipper: RadioCliper(reversed: true),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                top: 9,
                                bottom: 9,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4.0),
                                  bottomRight: Radius.circular(4.0),
                                ),
                                color: memberType == 2
                                    ? color1
                                    : Colors.transparent,
                              ),
                              child: Text(
                                '帳號',
                                style: TextStyle(
                                  color:
                                      memberType == 2 ? Colors.black : color5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  child: Column(
                    children: (memberType == 1
                            ? [
                                DataInputService('phone'),
                                DataInputService('驗證碼'),
                                DataInputService('邀請碼'),
                              ]
                            : registerMode
                                ? [
                                    DataInputService('帳號'),
                                    DataInputService('密碼'),
                                    DataInputService('驗證密碼'),
                                    DataInputService('邀請碼'),
                                  ]
                                : [
                                    DataInputService('帳號'),
                                    DataInputService('密碼'),
                                  ])
                        .asMap()
                        .map((idx, e) => MapEntry(idx, [
                              IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 4,
                                    bottom: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      memberType == 1 && idx == 0
                                          ? DropdownButton<String>(
                                              value: photoCountry,
                                              underline: Container(
                                                height: 0,
                                              ),
                                              icon: Container(
                                                width: 20,
                                                height: 20,
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.9),
                                                  color: color1,
                                                ),
                                                child: const VDIcon(
                                                  VIcons.back_black_2,
                                                ),
                                              ),
                                              items: [
                                                '',
                                                '+86',
                                                '+886',
                                              ]
                                                  .map(
                                                    (e) => DropdownMenuItem<
                                                        String>(
                                                      value: e.toString(),
                                                      child: Text(e),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (val) {
                                                setState(() {
                                                  photoCountry = val ?? '';
                                                });
                                              })
                                          : Text(
                                              e.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const VerticalDivider(
                                        thickness: 1,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                      ...([
                                        Expanded(
                                          flex: 12,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 0,
                                              bottom: 0,
                                            ),
                                            child: TextFormField(
                                              controller: idx == 0
                                                  ? _firstController
                                                  : idx == 1
                                                      ? _secondController
                                                      : idx == 2
                                                          ? _thirdController
                                                          : _forthController,
                                              onChanged: (v) {
                                                setState(() {
                                                  if (idx == 0) {
                                                    firstControllerEmpty =
                                                        v.isEmpty;
                                                    if (memberType == 2) {
                                                      if (!RegExp(
                                                              r'^[a-z0-9]{6,12}$',
                                                              caseSensitive:
                                                                  false)
                                                          .hasMatch(v)) {
                                                        firstError =
                                                            '帳號為 6-12 位字母及數字';
                                                      } else {
                                                        firstError = '';
                                                      }
                                                    } else {
                                                      if (!RegExp(
                                                              r'^[0-9]{10,12}$',
                                                              caseSensitive:
                                                                  false)
                                                          .hasMatch(v)) {
                                                        firstError =
                                                            '號碼需為 10-12 位數字';
                                                      } else {
                                                        firstError = '';
                                                        canSend = seconds <= 0;
                                                      }
                                                    }
                                                  } else if (idx == 1) {
                                                    secondControllerEmpty =
                                                        v.isEmpty;
                                                    if (memberType == 1) {
                                                      if (!RegExp(
                                                              r'^[a-z0-9]{6}$',
                                                              caseSensitive:
                                                                  false)
                                                          .hasMatch(v)) {
                                                        secondError =
                                                            '驗證碼為 6 位字母及數字';
                                                        isValidated = false;
                                                      } else {
                                                        secondError = '';
                                                        isValidated =
                                                            !firstControllerEmpty &&
                                                                !secondControllerEmpty &&
                                                                isChecked;
                                                      }
                                                    } else {
                                                      if (!RegExp(
                                                              r'^[a-z0-9]{8,20}$',
                                                              caseSensitive:
                                                                  false)
                                                          .hasMatch(v)) {
                                                        secondError =
                                                            '密碼為 8-20 位字母及數字';
                                                        isValidated = false;
                                                      } else {
                                                        secondError = '';
                                                        if (registerMode) {
                                                          isValidated = !firstControllerEmpty &&
                                                              !secondControllerEmpty &&
                                                              !thirdControllerEmpty &&
                                                              _secondController
                                                                      .text ==
                                                                  _thirdController
                                                                      .text;
                                                        } else {
                                                          isValidated =
                                                              !firstControllerEmpty &&
                                                                  !secondControllerEmpty;
                                                        }
                                                      }
                                                    }
                                                  } else if (idx == 2) {
                                                    thirdControllerEmpty =
                                                        v.isEmpty;
                                                    if (memberType == 2) {
                                                      if (v !=
                                                          _secondController
                                                              .text) {
                                                        thirdError = '二次密碼不相符';
                                                        isValidated = false;
                                                      } else {
                                                        thirdError = '';
                                                        isValidated = !firstControllerEmpty &&
                                                            !secondControllerEmpty &&
                                                            !thirdControllerEmpty &&
                                                            _secondController
                                                                    .text ==
                                                                _thirdController
                                                                    .text;
                                                      }
                                                    }
                                                  } else {
                                                    forthControllerEmpty =
                                                        v.isEmpty;
                                                  }
                                                });
                                              },
                                              autofocus: false,
                                              obscureText: memberType == 2 &&
                                                  (idx == 1 || idx == 2),
                                              keyboardType:
                                                  memberType == 1 && idx == 0
                                                      ? TextInputType.number
                                                      : TextInputType.text,
                                              decoration: InputDecoration(
                                                filled: false,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  left: 5,
                                                  top: 0,
                                                  bottom: 0,
                                                ),
                                                suffixIcon: (idx == 0
                                                        ? firstControllerEmpty
                                                        : idx == 1
                                                            ? secondControllerEmpty
                                                            : idx == 2
                                                                ? thirdControllerEmpty
                                                                : forthControllerEmpty)
                                                    ? null
                                                    : InkWell(
                                                        onTap: () {
                                                          (idx == 0
                                                                  ? _firstController
                                                                  : idx == 1
                                                                      ? _secondController
                                                                      : idx == 2
                                                                          ? _thirdController
                                                                          : _forthController)
                                                              .clear();
                                                          setState(() {
                                                            if (idx == 0) {
                                                              firstControllerEmpty =
                                                                  true;
                                                              firstError = '';
                                                            } else if (idx ==
                                                                1) {
                                                              secondControllerEmpty =
                                                                  true;
                                                              secondError = '';
                                                            } else if (idx ==
                                                                2) {
                                                              thirdControllerEmpty =
                                                                  true;
                                                              thirdError = '';
                                                            } else {
                                                              forthControllerEmpty =
                                                                  true;
                                                              forthError = '';
                                                            }
                                                            if (memberType ==
                                                                        1 &&
                                                                    idx < 2 ||
                                                                memberType ==
                                                                        2 &&
                                                                    idx < 3) {
                                                              isValidated =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: const VDIcon(
                                                              VIcons
                                                                  .searchclose),
                                                        ),
                                                      ),
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                                // hintText: '輸入番號、女優名或...',
                                                hintText: '輸入${e.title}',
                                                hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      167, 167, 167, 1),
                                                ),
                                                focusColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...((memberType == 1 && idx == 1)
                                            ? [
                                                Expanded(
                                                  flex: 8,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (canSend) {
                                                        if (_firstController
                                                                .text.length !=
                                                            11) {
                                                          alertModal(
                                                              title: '號碼錯誤',
                                                              content:
                                                                  '號碼長度須為11 位');
                                                          return;
                                                        }
                                                        if (!RegExp(r'^1')
                                                            .hasMatch(
                                                                _firstController
                                                                    .text)) {
                                                          alertModal(
                                                              title: '號碼錯誤',
                                                              content:
                                                                  '號碼開頭須為1');
                                                          return;
                                                        }
                                                        try {
                                                          var otp = await Get.find<
                                                                  OtpProvider>()
                                                              .getPinCode(
                                                                  _firstController
                                                                      .text,
                                                                  user?.uid ??
                                                                      0);
                                                          if (otp == true) {
                                                            alertModal(
                                                                title: '成功',
                                                                content:
                                                                    '簡訊發送成功');
                                                          }
                                                        } on OtpException catch (e) {
                                                          alertModal(
                                                              title: '發送失敗',
                                                              content:
                                                                  e.toString());
                                                        }
                                                        sendValidatedCode();
                                                      }
                                                    },
                                                    child: Transform(
                                                      transform: Matrix4
                                                          .translationValues(
                                                              20, 0, 0),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 10,
                                                          bottom: 10,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          color: !canSend
                                                              ? color7
                                                              : color1,
                                                        ),
                                                        child: Text(
                                                          seconds > 0
                                                              ? '$seconds s'
                                                              : '發送驗證碼',
                                                          style: TextStyle(
                                                            color: !canSend
                                                                ? color5
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            : []),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: color7,
                                thickness: 1,
                              ),
                              ...((idx == 0 && firstError.isNotEmpty)
                                  ? [
                                      Text(
                                        firstError,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ]
                                  : [const SizedBox()]),
                              ...((idx == 1 && secondError.isNotEmpty)
                                  ? [
                                      Text(
                                        secondError,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ]
                                  : [const SizedBox()]),
                              ...((idx == 2 && thirdError.isNotEmpty)
                                  ? [
                                      Text(
                                        thirdError,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ]
                                  : [const SizedBox()]),
                            ]))
                        .values
                        .reduce((value, element) => [
                              ...value,
                              ...element,
                            ])
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                ...(!registerMode || memberType == 1
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 32,
                            right: 32,
                          ),
                          child: InkWell(
                            onTap: () async {
                              AppController app = Get.find<AppController>();
                              if (isValidated) {
                                if (memberType == 1) {
                                  try {
                                    var authToken =
                                        await Get.find<AuthProvider>()
                                            .registerByPhone(
                                      phoneNumber: _firstController.text,
                                      pin: _secondController.text,
                                    );
                                    if (authToken == null) {
                                      alertModal(title: '提示', content: '註冊失敗');
                                      return;
                                    } else {
                                      await alertModal(
                                          title: '成功提示', content: '註冊成功');
                                    }
                                    app.login(authToken);
                                  } on RegisterException catch (e) {
                                    await alertModal(
                                        title: '提示', content: e.toString());
                                    return;
                                  }
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/default',
                                      (Route<dynamic> route) => false);
                                } else {
                                  if (registerMode) {
                                    try {
                                      var result =
                                          await Get.find<AuthProvider>()
                                              .register(
                                        username: _firstController.text,
                                        password: _secondController.text,
                                      );
                                      if (result == null) {
                                        await alertModal(
                                            title: '提示', content: '註冊失敗');
                                        return;
                                      } else {
                                        await alertModal(
                                            title: '成功提示', content: '註冊成功');
                                      }
                                    } on RegisterException catch (e) {
                                      await alertModal(
                                          title: '提示', content: e.toString());
                                      return;
                                    }
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/default',
                                            (Route<dynamic> route) => false);
                                  } else {
                                    var authToken =
                                        await Get.find<AuthProvider>().login(
                                      username: _firstController.text,
                                      password: _secondController.text,
                                    );
                                    if (authToken == null) {
                                      await alertModal(
                                          title: '提示', content: '登入失敗');
                                      return;
                                    } else {
                                      await alertModal(
                                          title: '成功提示', content: '登入成功');
                                    }
                                    app.login(authToken);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/default',
                                            (Route<dynamic> route) => false);
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: !isValidated ? color7 : color1,
                              ),
                              child: Text(
                                '立即登錄',
                                style: TextStyle(
                                  color: !isValidated ? color5 : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 32,
                            right: 32,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if (isValidated) {
                                      try {
                                        await Get.find<AuthProvider>().register(
                                          username: _firstController.text,
                                          password: _secondController.text,
                                        );
                                      } on RegisterException catch (e) {
                                        await alertModal(
                                            title: '提示', content: e.toString());
                                        return;
                                      }

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/default',
                                              (Route<dynamic> route) => false);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: !isValidated ? color7 : color1,
                                    ),
                                    child: Text(
                                      '註冊',
                                      style: TextStyle(
                                        color: !isValidated
                                            ? color5
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      registerMode = false;
                                      _firstController.clear();
                                      _secondController.clear();
                                      _thirdController.clear();
                                      _forthController.clear();
                                      firstControllerEmpty = true;
                                      secondControllerEmpty = true;
                                      thirdControllerEmpty = true;
                                      forthControllerEmpty = true;
                                      canSend = false;
                                      isChecked = memberType == 2;
                                      firstError = '';
                                      secondError = '';
                                      thirdError = '';
                                      forthError = '';
                                      isValidated = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: color6,
                                    ),
                                    child: const Text(
                                      '取消',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                const SizedBox(
                  height: 30,
                ),
                ...(memberType == 2
                    ? []
                    : [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 28,
                            right: 32,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (val) {
                                  setState(() {
                                    isChecked = val ?? false;
                                    isValidated = !firstControllerEmpty &&
                                        !secondControllerEmpty &&
                                        isChecked;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                              ),
                              const Expanded(
                                child: Text(
                                  '我已閱讀並同意用戶協議和隱私政策，並註冊綁定的手機號碼驗證成功後將自動註冊。',
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                SizedBox(
                  height: registerMode ? 100 : (gs().height - 400) / 2,
                ),
                ...(memberType == 1 || registerMode
                    ? []
                    : [
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    registerMode = !registerMode;
                                    _firstController.clear();
                                    _secondController.clear();
                                    _thirdController.clear();
                                    _forthController.clear();
                                    firstControllerEmpty = true;
                                    secondControllerEmpty = true;
                                    thirdControllerEmpty = true;
                                    forthControllerEmpty = true;
                                    canSend = false;
                                    isChecked = memberType == 2;
                                    firstError = '';
                                    secondError = '';
                                    thirdError = '';
                                    forthError = '';
                                    isValidated = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 20, left: 20),
                                  child: Text(registerMode ? '已有帳號' : '還沒有帳號'),
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 1,
                                indent: 7,
                                endIndent: 7,
                              ),
                              InkWell(
                                onTap: () {
                                  alertModal(
                                      title: '忘記密碼', content: '請聯繫客服，或用身份卡登入');
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20, right: 20),
                                  child: const Text('忘記密碼'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
