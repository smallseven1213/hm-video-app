import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class ShareTutorialPage extends StatefulWidget {
  const ShareTutorialPage({Key? key}) : super(key: key);

  @override
  _ShareTutorialPageState createState() => _ShareTutorialPageState();
}

class _ShareTutorialPageState extends State<ShareTutorialPage> {
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
                  '推廣教學',
                  style: TextStyle(
                    fontSize: 15,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  SizedBox(height: 24,),
                  buildTitle("1. 通過微信群分享"),
                  SizedBox(height: 9,),
                  buildContent("把推廣二維碼或者邀請鏈接分享到微信基友群通過微信群分享"),
                  SizedBox(height: 16,),
                  buildTitle("2. 通過QQ群分享"),
                  SizedBox(height: 9,),
                  buildContent("把推廣二維碼或者邀請鏈接分享到QQ基友群"),
                  SizedBox(height: 16,),
                  buildTitle("3. 通過微信、QQ好友分享"),
                  SizedBox(height: 9,),
                  buildContent("把推廣二維碼或者邀請鏈接發送給好基友分享"),
                  SizedBox(height: 16,),
                  buildTitle("4. 通過附近的人分享"),
                  SizedBox(height: 9,),
                  buildContent("可以通過QQ附近的人、陌陌、探探、Soul等推廣"),
                  SizedBox(height: 16,),
                  buildTitle("5. 通過百度貼吧 各大論壇推廣"),
                  SizedBox(height: 9,),
                  buildContent("把二維碼圖片分享到貼吧及各大論壇社區"),
                  SizedBox(height: 16,),
                  buildTitle("6. 通過新聞APP推廣"),
                  SizedBox(height: 9,),
                  buildContent("可以通過網易新聞、今日頭條、皮皮蝦等新聞APP評論區推廣您的二維碼或鏈接"),
                  SizedBox(height: 16,),


                ],
              ),
            )
          ),
        ),
      ),
      bottomSheet:  Container(
        height: 90,
        alignment: Alignment.center,
        decoration:
        const BoxDecoration(color: Color.fromRGBO(0, 0, 0, .65)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () async {
                back();
              },
              child: Container(
                width: (gs().width - 32),
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text(
                  '學會了，去推廣',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align buildContent(String s) => Align(
    alignment: Alignment.topLeft,
    child: Text(
      s,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  Align buildTitle(String s) =>  Align(
    alignment: Alignment.topLeft,
    child: Text(
      s,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
