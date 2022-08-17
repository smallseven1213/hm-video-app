import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class MemberSettingsPasswordPage extends StatefulWidget {
  const MemberSettingsPasswordPage({Key? key}) : super(key: key);

  @override
  _MemberSettingsPasswordPageState createState() =>
      _MemberSettingsPasswordPageState();
}

class _MemberSettingsPasswordPageState
    extends State<MemberSettingsPasswordPage> {
  bool isValidated = false;
  bool isOriginValidated = false;
  bool isObscureText = true;
  bool originControllerEmpty = false;
  bool newControllerEmpty = false;
  bool validatedControllerEmpty = false;
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _validatedController = TextEditingController();
  String secondError = '';
  String thirdError = '';

  @override
  void initState() {
    _originController.addListener(() {
//      print(_originController.text);
      setState(() {
        isOriginValidated = _originController.text.length > 4;
      });
    });
    _newController.addListener(() {});
    _validatedController.addListener(() {
      setState(() {
        isValidated = isOriginValidated &&
            (_validatedController.text.length > 4 &&
                _validatedController.text == _newController.text);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _originController.dispose();
    _newController.dispose();
    _validatedController.dispose();
    super.dispose();
  }

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
                  '修改密碼',
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
              children: [
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    DataInputService('原密碼'),
                    DataInputService('新密碼'),
                    DataInputService('驗證密碼'),
                  ]
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
                                    Text(
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
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          top: 0,
                                          bottom: 0,
                                        ),
                                        child: TextFormField(
                                          controller: idx == 0
                                              ? _originController
                                              : idx == 1
                                                  ? _newController
                                                  : _validatedController,
                                          onChanged: (v) {
                                            setState(() {
                                              if (idx == 0) {
                                                originControllerEmpty =
                                                    v.isEmpty;
                                              } else if (idx == 1) {
                                                newControllerEmpty = v.isEmpty;
                                                if (!RegExp(r'^[a-z0-9]{8,20}$', caseSensitive: false).hasMatch(v)) {
                                                  secondError = '密碼為 8-20 位字母及數字';
                                                  isValidated = false;
                                                } else {
                                                  secondError = '';
                                                }
                                              } else {
                                                if (v != _newController.text) {
                                                  thirdError = '二次密碼不相符';
                                                  isValidated = false;
                                                } else {
                                                  thirdError = '';
                                                }

                                                validatedControllerEmpty =
                                                    v.isEmpty;
                                                isValidated =
                                                    !originControllerEmpty &&
                                                        !validatedControllerEmpty &&
                                                        _newController.text ==
                                                            _validatedController
                                                                .text;
                                              }
                                            });
                                          },
                                          obscureText: isObscureText,
                                          decoration: InputDecoration(
                                            filled: false,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 5,
                                              top: 0,
                                              bottom: 0,
                                            ),
                                            suffixIcon: (idx == 0
                                                    ? originControllerEmpty
                                                    : idx == 1
                                                        ? newControllerEmpty
                                                        : validatedControllerEmpty)
                                                ? null
                                                : InkWell(
                                                    onTap: () {
                                                      (idx == 0
                                                              ? _originController
                                                              : idx == 1
                                                                  ? _newController
                                                                  : _validatedController)
                                                          .clear();
                                                      setState(() {
                                                        if (idx == 0) {
                                                          originControllerEmpty =
                                                              true;
                                                        } else if (idx == 1) {
                                                          secondError = '';
                                                          newControllerEmpty =
                                                              true;
                                                        } else {
                                                          thirdError = '';
                                                          validatedControllerEmpty =
                                                              true;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: const VDIcon(
                                                          VIcons.searchclose),
                                                    ),
                                                  ),
                                            border: const OutlineInputBorder(
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
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              color: color7,
                              thickness: 1,
                            ),
                          const SizedBox(),
                          ...((idx == 1 && secondError.isNotEmpty)
                              ? [
                            Text(
                              secondError,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ] : [const SizedBox()]),
                        ...((idx == 2 && thirdError.isNotEmpty)
                            ? [
                          Text(
                            thirdError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ] : [const SizedBox()]),
                          ]))
                      .values
                      .reduce((value, element) => [
                            ...value,
                            ...element,
                          ])
                      .toList(),
                ),
                const SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (isValidated) {
                        await Get.find<UserProvider>().updatePassword(
                            _originController.text, _newController.text);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/member', (Route<dynamic> route) => false);
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
                        '確認修改',
                        style: TextStyle(
                          color: !isValidated ? color5 : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
