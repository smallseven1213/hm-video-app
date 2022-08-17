import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class MemberSettingsPage extends StatefulWidget {
  const MemberSettingsPage({Key? key}) : super(key: key);

  @override
  _MemberSettingsPageState createState() => _MemberSettingsPageState();
}

class _MemberSettingsPageState extends State<MemberSettingsPage> {
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
              child: Center(
                child: Text(
                  '設置',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
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
                    DataService(VIcons.lock, '修改密碼', onTap: () {
                      gto('/member/setting/password');
                    }),
                    DataService(VIcons.invite, '填寫邀請碼'),
                    // DataService(VIcons.trash, '清除緩存'),
                  ]
                      .map((e) => [
                            InkWell(
                              onTap: e.onTap ?? () {},
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VDIcon(e.icon),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.title,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    const VDIcon(VIcons.arrow_2_right),
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
                // const SizedBox(
                //   height: 150,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     left: 16,
                //     right: 16,
                //   ),
                //   child: InkWell(
                //     onTap: () {},
                //     child: Container(
                //       padding: const EdgeInsets.only(
                //         top: 10,
                //         bottom: 10,
                //       ),
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(4.0),
                //         color: color1,
                //       ),
                //       child: const Text('退出登錄'),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
