import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class MemberSettingNicknamePage extends StatefulWidget {
  const MemberSettingNicknamePage({Key? key}) : super(key: key);

  @override
  _MemberSettingNicknamePageState createState() =>
      _MemberSettingNicknamePageState();
}

class _MemberSettingNicknamePageState extends State<MemberSettingNicknamePage> {
  bool isValidated = false;
  bool isOriginValidated = false;
  bool isObscureText = false;
  bool originControllerEmpty = false;
  final TextEditingController _originController = TextEditingController();

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
                  '修改暱稱',
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
                    DataInputService('新暱稱'),
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
                                          controller: _originController,
                                          onChanged: (v) {
                                            setState(() {
                                              if (idx == 0) {
                                                originControllerEmpty =
                                                    v.isEmpty;
                                                isValidated =
                                                    !originControllerEmpty;
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
                                            suffixIcon: originControllerEmpty
                                                ? null
                                                : InkWell(
                                                    onTap: () {
                                                      _originController.clear();
                                                      setState(() {
                                                        if (idx == 0) {
                                                          originControllerEmpty =
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
                        await Get.find<UserProvider>()
                            .updateNickname(_originController.text);
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
                        '設置完成',
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
