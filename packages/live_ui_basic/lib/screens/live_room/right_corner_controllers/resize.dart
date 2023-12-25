import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class Resize extends StatelessWidget {
  const Resize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return ShareView();
          },
        );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/resize_button.webp',
          width: 33,
          height: 33),
    );
  }
}

class ShareView extends StatelessWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF242a3d),
            ),
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("分享到",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 17),
                _createButton(
                    context,
                    Image.asset(
                        'packages/live_ui_basic/assets/images/share_link_button.webp',
                        width: 33,
                        height: 33),
                    '複製連結', onPressed: () {
                  FlutterClipboard.copy('hello flutter friends').then((value) {
                    Fluttertoast.showToast(
                      msg: "複製成功",
                      gravity: ToastGravity.BOTTOM,
                    );
                  });
                })
                // GridView.count(
                //   crossAxisCount: 4,
                //   children: <Widget>[
                //     // _createButton(context, Icons.facebook, 'Facebook'),
                //     // _createButton(context, Icons.chat, 'Line'),
                //     // _createButton(context, Icons.camera_alt, '相機'),
                //     _createButton(context, Icons.games, '複製連結'),
                //   ],
                // )
              ],
            ),
          ),
          // height 10
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF242a3d),
              ),
              height: 43,
              child: Center(
                child: Text("取消",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createButton(BuildContext context, Widget icon, String label,
      {Function()? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          const SizedBox(height: 9),
          Text(label,
              style: const TextStyle(color: Color(0xFFaaaaa7), fontSize: 9))
        ],
      ),
    );
  }
}
