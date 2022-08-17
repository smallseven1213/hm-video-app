import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class PaymentResultPage extends StatefulWidget {
  const PaymentResultPage({Key? key}) : super(key: key);

  @override
  _PaymentResultPageState createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage> {
  @override
  void initState() {
    super.initState();
    // try {
    //   Get.find<OrderProvider>()
    //       .makeOrder(
    //     productId: int.parse(Get.parameters['productId'].toString()),
    //     paymentChannelId: int.parse(Get.parameters['method'].toString()),
    //   )
    //       .then((value) {
    //     if (value.isNotEmpty && value.startsWith('http')) {
    //       launch(
    //         value,
    //         forceWebView: kIsWeb,
    //         enableJavaScript: true,
    //         forceSafariVC: true,
    //       );
    //     } else {
    //       alertModal(
    //         title: '交易失敗',
    //         content: '訂單建立失敗',
    //         onTap: () {
    //           Navigator.pop(context);
    //         },
    //       );
    //     }
    //   });
    // } catch (e) {}
  }

  Future<void> alertModal(
      {String title = '', String content = '', VoidCallback? onTap}) async {
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
                    if (onTap != null) {
                      onTap();
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
                  '支付確認中',
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 78,
                ),
                const SizedBox(
                  width: 80,
                  height: 170,
                  child:
                      Image(image: AssetImage('assets/img/processing@3x.png')),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('訂單已建立，支付確認中...'),
                const SizedBox(
                  height: 48,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/default', (Route<dynamic> route) => false);
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
                    child: const Text('去看視頻'),
                  ),
                ),
                const SizedBox(
                  height: 72,
                ),
                Container(
                  width: gs().width - 32,
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    color: color7,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '溫馨提醒',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '1：支付不成功，請多次嘗試支付。',
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                      ),
                      Text(
                        '2：無法拉起支付訂單，是由於拉起訂單人數較多，請多次嘗試拉起支付。',
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                      ),
                      Text(
                        '3：充值成功VIP未到賬，請聯繫在線客服。',
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                      ),
                    ],
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
