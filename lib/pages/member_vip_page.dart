import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class MemberVipPage extends StatefulWidget {
  final String? refer;

  const MemberVipPage({Key? key, this.refer}) : super(key: key);

  @override
  _MemberVipPageState createState() => _MemberVipPageState();
}

class _MemberVipPageState extends State<MemberVipPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController tabController;
  int tabIndex = 0;
  bool isChecked = false;
  int paymentMethod = 0;
  int status = 0;
  bool isLoading = false;
  bool paymentOpened = false;
  List<Product> products = [];

  @override
  void initState() {
    Get.find<ProductProvider>().getManyBy(type: 2).then((value) {
      setState(() {
        products = value;
      });
    });
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      changeTab(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    tabController.animateTo(
      index,
      duration: Duration.zero,
      curve: Curves.linear,
    );
    setState(() {
      tabIndex = index;
    });
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

  Future<void> showPaymentMethod(BuildContext context, int productId,
      String balanceFiatMoneyPrice, String name) async {
    if (paymentOpened) return;
    paymentOpened = true;
    List<Payment> payments =
        await Get.find<PaymentProvider>().getPaymentsBy(productId);
    if (payments.isNotEmpty) {
      paymentMethod = payments.first.id;
    } else {
      alertModal(title: "提示", content: "當前支付人數過多，請稍後再試。");
      paymentOpened = false;
      return;
    }
    await showModalBottomSheet(
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SizedBox(
              height: (kIsWeb ? 150 : 180) + payments.length * 70,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      const Center(
                        child: Text(
                          "請選擇支付方式",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(ctx);
                            },
                            child: const VDIcon(VIcons.close),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          top: 18,
                          bottom: 11,
                          left: 20,
                        ),
                        child: Text("已選擇$name",
                            style: const TextStyle(fontSize: 12)),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          top: 18,
                          bottom: 11,
                        ),
                        child: Text(" ¥${balanceFiatMoneyPrice}",
                            style:
                                const TextStyle(fontSize: 15, color: color15)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      ...payments.map((e) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            onTap: () async {
                              setModalState(() {
                                // if (paymentMethod == e.id) {
                                //   paymentMethod = 0;
                                //   return;
                                // }
                                paymentMethod = e.id;
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color:
                                      paymentMethod == e.id ? color1 : color7,
                                ),
                              ),
                              child: Row(
                                children: [
                                  e.type == "支付寶"
                                      ? const VDIcon(VIcons.payment_alipay)
                                      : e.type == "雲閃付"
                                          ? const VDIcon(
                                              VIcons.payment_quickpass)
                                          : e.type == "銀行卡"
                                              ? const VDIcon(
                                                  VIcons.payment_paypal)
                                              : const VDIcon(
                                                  VIcons.payment_wechat),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(child: Text(e.type)),
                                  Checkbox(
                                    activeColor: color1,
                                    checkColor: Colors.black,
                                    value: paymentMethod == e.id,
                                    onChanged: (val) {
                                      if (val == true) {
                                        setModalState(() {
                                          paymentMethod = e.id;
                                        });
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(64.0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      if (paymentMethod == 0) {
                        return;
                      }

                      var windowRef = null;
                      if (kIsWeb) windowRef = html.window.open('', '_blank');

                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 66));
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        var value = await Get.find<OrderProvider>().makeOrder(
                          productId: productId,
                          paymentChannelId: paymentMethod,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (value.isNotEmpty && value.startsWith('http')) {
//                          debounce(() async => {
                          if (kIsWeb) {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            windowRef?.location.href = value;
//                                 alertModal(
//                                 title: '確認購買',
//                                 content: '請再次確認是否購買',
//                                 onTap: () async {
//                                   await launch(
//                                     value,
//                                     // forceWebView: !kIsWeb,
//                                     // enableJavaScript: true,
//                                     // forceSafariVC: true,
//                                   );
                            gto('/member/wallet/payment-result/$productId/$paymentMethod');
//                                 });
                          } else {
                            await launch(value,
                                // forceWebView: !kIsWeb,
                                // enableJavaScript: true,
                                // forceSafariVC: true,
                                webOnlyWindowName: '_blank');
                            gto('/member/wallet/payment-result/$productId/$paymentMethod');
                          }

//                          })();

                        } else {
                          alertModal(
                            title: '交易失敗',
                            content: '訂單建立失敗',
                            onTap: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
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
                      child: const Text('確認支付'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    // paymentMethod = 0;
    paymentOpened = false;
  }

  Map<String, Timer> _funcDebounce = {};
  Function debounce(Function func, [int milliseconds = 2000]) {
    Function target = () {
      String key = func.hashCode.toString();
      Timer? _timer = _funcDebounce[key];
      if (_timer == null) {
        func.call();
        _timer = Timer(Duration(milliseconds: milliseconds), () {
          Timer? t = _funcDebounce.remove(key);
          t?.cancel();
          t = null;
        });
        _funcDebounce[key] = _timer;
      }
    };
    return target;
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
    return SafeArea(
      top: false,
      child: Scaffold(
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
          leading: widget.refer == 'home'
              ? Container()
              : InkWell(
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
                    'VIP會員',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Center(
          child: FutureBuilder<User>(
            future: Get.find<UserProvider>().getCurrentUser(),
            builder: (_ctx, _snapshot) {
              var user = _snapshot.data ?? User('', 0, ['guest']);
              return !_snapshot.hasData
                  ? const VDLoading()
                  : Stack(
                      children: [
                        NestedScrollView(
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                backgroundColor: Colors.white,
                                toolbarHeight: 0,
                                collapsedHeight: 92 + 44,
                                expandedHeight: 92 + 44,
                                pinned: true,
                                elevation: 0,
                                flexibleSpace: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // AnimatedContainer(
                                    //   duration: const Duration(milliseconds: 66),
                                    //   width: gs().width,
                                    //   height: 280,
                                    //   decoration: BoxDecoration(
                                    //     color: tabIndex == 0
                                    //         ? color13
                                    //         : Colors.transparent,
                                    //   ),
                                    // ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 0,
                                            left: 27,
                                          ),
                                          child: Column(
                                            // mainAxisAlignment:MainAxisAlignment.center,
                                            // crossAxisAlignment:CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  FutureBuilder<String>(
                                                    future:
                                                        AuthProvider.getToken(),
                                                    builder: (_cctx, _ssnap) =>
                                                        (!_ssnap.hasData ||
                                                                (user.avatar ==
                                                                        null ||
                                                                    user.avatar
                                                                            ?.isEmpty ==
                                                                        true))
                                                            ? Column(
                                                                children: [
                                                                  Container(
                                                                    height: 16,
                                                                  ),
                                                                  SizedBox(
                                                                    child:
                                                                        const CircleAvatar(
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              'assets/img/icon-supplier@3x.png'),
                                                                    ),
                                                                    width: 60,
                                                                    height: 60,
                                                                  )
                                                                ],
                                                              )
                                                            : user.isForeverFree()
                                                                ? Stack(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Positioned(
                                                                        top: 16,
                                                                        left:
                                                                            0.7,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            child:
                                                                                ClipOval(
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: SizedBox(
                                                                                width: 55,
                                                                                height: 55,
                                                                                child: VDImage(
                                                                                  url: user.avatar ?? '',
                                                                                  headers: {
                                                                                    'Authorization': _ssnap.data ?? '',
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 3),
                                                                        width:
                                                                            62,
                                                                        height:
                                                                            79,
                                                                        // alignment:
                                                                        // Alignment
                                                                        //     .center,
                                                                        child:
                                                                            Image(
                                                                          image:
                                                                              AssetImage('assets/png/bitmap@3x.png'),
                                                                          height:
                                                                              79,
                                                                          width:
                                                                              62,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : user.isGuest()
                                                                    ? Container(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                16,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            ClipOval(
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                            child:
                                                                                VDImage(
                                                                              url: user.avatar ?? "",
                                                                              // width: 60,
                                                                              // height: 60,
                                                                              headers: {
                                                                                'Authorization': _ssnap.data ?? '',
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                16
                                                                            //     bottom: 10
                                                                            ),
                                                                        child:
                                                                            ClipOval(
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                            child:
                                                                                VDImage(
                                                                              url: user.avatar ?? '',
                                                                              // width: 60,
                                                                              // height: 60,
                                                                              headers: {
                                                                                'Authorization': _ssnap.data ?? '',
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    // mainAxisAlignment:
                                                    // MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      user.isGuest()
                                                          ? Text(
                                                              '訪客${user.isGuest() ? user.uid : ''}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            )
                                                          : Text(
                                                              user.nickname ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        'ID: ${user.uid}',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Color(0xffb3b3b3),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      // left: 16,
                                      // right: 16,
                                      bottom: 0,
                                      child: Container(
                                        width: gs().width,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16)),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                              // spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(3, -7),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                  enableFeedback: true,
                                                  onTap: () {
                                                    changeTab(0);
                                                  },
                                                  child: IntrinsicWidth(
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'VIP',
                                                            style: TextStyle(
                                                              fontWeight: tabController
                                                                          .index ==
                                                                      0
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  tabController
                                                                              .index ==
                                                                          0
                                                                      ? 16
                                                                      : 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 9,
                                                        ),
                                                        tabIndex == 0
                                                            ? Divider(
                                                                color: Color(
                                                                    0xffffdc00),
                                                                thickness: 3,
                                                                indent: 39,
                                                                endIndent: 39,
                                                                height: 3)
                                                            : Container()
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            VerticalDivider(
                                              thickness: 1,
                                              indent: 14,
                                              endIndent: 20,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                  enableFeedback: true,
                                                  onTap: () {
                                                    changeTab(1);
                                                  },
                                                  child: IntrinsicWidth(
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            '特權紀錄',
                                                            style: TextStyle(
                                                              fontWeight: tabController
                                                                          .index ==
                                                                      1
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  tabController
                                                                              .index ==
                                                                          1
                                                                      ? 16
                                                                      : 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 9,
                                                        ),
                                                        tabIndex == 1
                                                            ? Divider(
                                                                color: Color(
                                                                    0xffffdc00),
                                                                thickness: 3,
                                                                indent: 39,
                                                                endIndent: 39,
                                                                height: 3)
                                                            : Container()
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            const VerticalDivider(
                                              thickness: 1,
                                              indent: 14,
                                              endIndent: 20,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                  enableFeedback: true,
                                                  onTap: () {
                                                    changeTab(2);
                                                  },
                                                  child: IntrinsicWidth(
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            '存款記錄',
                                                            style: TextStyle(
                                                              fontWeight: tabController
                                                                          .index ==
                                                                      2
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  tabController
                                                                              .index ==
                                                                          2
                                                                      ? 16
                                                                      : 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 9,
                                                        ),
                                                        tabIndex == 2
                                                            ? Divider(
                                                                color: Color(
                                                                    0xffffdc00),
                                                                thickness: 3,
                                                                indent: 39,
                                                                endIndent: 39,
                                                                height: 3)
                                                            : Container()
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Positioned(
                                            top: 27,
                                            right: 0,
                                            child: user.isVip()
                                                ? Container(
                                                    height: 38,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 18,
                                                      right: 8,
                                                      top: 4,
                                                      bottom: 3,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin:
                                                              FractionalOffset
                                                                  .topLeft,
                                                          end: FractionalOffset
                                                              .bottomRight,
                                                          colors: [
                                                            Color(0xff6ccff3),
                                                            Color(0xff6775ce),
                                                          ],
                                                          stops: [
                                                            0.0,
                                                            1.0
                                                          ]),
                                                      color: Colors.amberAccent,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          user.isForeverFree()
                                                              ? '永久至尊特權會員'
                                                              : 'VIP會員',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                        ),
                                                        Text(
                                                          '效期至：${DateFormat("yyyy/MM/dd").format(user.getVipExpiredAt() ?? DateTime.now())}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : user.isGuest()
                                                    ? const Text(
                                                        '',
                                                        style: TextStyle(
                                                          color: color14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ];
                          },
                          body: Container(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        FutureBuilder<List<Product>>(
                                          future: Future.value(products),
                                          builder: (_ctx, _ss) {
                                            if (!_ss.hasData) {
                                              return const SizedBox.shrink();
                                            }
                                            var products = _ss.data ?? [];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                              ),
                                              child: Column(
                                                children: [
                                                  ...products.map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        showPaymentMethod(
                                                            context,
                                                            e.id ?? 0,
                                                            e.balanceFiatMoneyPrice ??
                                                                '',
                                                            e.name ?? '');
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width:
                                                                gs().width - 40,
                                                            height:
                                                                (gs().width -
                                                                        40) *
                                                                    0.347,
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 0,
                                                              bottom:
                                                                  (gs().width -
                                                                          40) *
                                                                      0.347 *
                                                                      0.101,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              // image: DecorationImage(
                                                              //     image: NetworkImage(e
                                                              //         .getProductImageUrl()),
                                                              //     fit: BoxFit
                                                              //         .fitWidth),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      gs().width -
                                                                          40,
                                                                  height:
                                                                      (gs().width -
                                                                              40) *
                                                                          0.347,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                    child:
                                                                        VDImage(
                                                                      url: e
                                                                          .getProductImageUrl(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: (gs().width -
                                                                            40) *
                                                                        0.347 *
                                                                        0.154,
                                                                    left: (gs().width -
                                                                            40) *
                                                                        0.088,
                                                                    bottom: (gs().width -
                                                                            40) *
                                                                        0.347 *
                                                                        0.101,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Container(),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  e.name ?? '',
                                                                                  style: const TextStyle(
                                                                                    fontSize: 16,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 4,
                                                                                ),
                                                                                Text(
                                                                                  e.description ?? '',
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: gs().height > 650 ? ((gs().width - 40) * 0.347 * 0.169) : 10,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Expanded(
                                                                                        flex: 1,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            const Text(
                                                                                              '¥ ',
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 12,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              '${e.discount ?? 0}',
                                                                                              style: const TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 20,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        )),
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              const Text(
                                                                                                '原價',
                                                                                                style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                  fontSize: 11,
                                                                                                ),
                                                                                              ),
                                                                                              Row(children: [
                                                                                                const Text(
                                                                                                  '¥ ',
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 12,
                                                                                                    decoration: TextDecoration.lineThrough,
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  e.fiatMoneyPrice ?? '0.00',
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 13,
                                                                                                    decoration: TextDecoration.lineThrough,
                                                                                                  ),
                                                                                                )
                                                                                              ])
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            padding: const EdgeInsets.only(
                                                                                              right: 18,
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          ...(e.subTitle
                                                                      ?.isNotEmpty ==
                                                                  true
                                                              ? [
                                                                  Positioned(
                                                                    right: 0,
                                                                    // top: 5,
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5,
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                      ),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end: Alignment.centerRight,
                                                                            colors: [
                                                                              Color(0xfffdff59),
                                                                              Color(0xff82ce67),
                                                                            ],
                                                                            stops: [
                                                                              0.0,
                                                                              1.0
                                                                            ]),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(16),
                                                                          topRight:
                                                                              Radius.circular(16),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        e.subTitle
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              color14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]
                                                              : []),
                                                          ...((e.bundles ?? [])
                                                                  .isNotEmpty
                                                              ? [
                                                                  Positioned(
                                                                      left: 15,
                                                                      top: (gs().width -
                                                                              40) *
                                                                          0.347 *
                                                                          0.737,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3,
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .transparent
                                                                              .withOpacity(0.15),
                                                                          borderRadius:
                                                                              BorderRadius.circular(14.0),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          (e.bundles ??
                                                                                  [
                                                                                    Bundle(0, '')
                                                                                  ])[0]
                                                                              .name
                                                                              .toString(),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                11,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                ]
                                                              : []),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                  const SizedBox(
                                                    height: 24,
                                                  ),
                                                  Container(
                                                    width: gs().width - 32,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 12,
                                                      bottom: 12,
                                                      left: 16,
                                                      right: 16,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: color7_05,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Text(
                                                          '溫馨提醒',
                                                          style: TextStyle(
                                                            color: color30,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          '1：支付不成功，請多次嘗試支付。',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: color30,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          '2：無法拉起支付訂單，是由於拉起訂單人數較多，請多次嘗試拉起支付。',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: color30,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          '3：充值成功 VIP 未到賬，請聯繫在線客服。',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: color30,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 36,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('只顯示有效',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    )),
                                                Checkbox(
                                                  value: isChecked,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      isChecked = val ?? false;
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        FutureBuilder<
                                            List<UserPrivilegeRecord>>(
                                          future: Get.find<PrivilegeProvider>()
                                              .getUserPrivilegeRecords(
                                                  userId: user.id),
                                          builder: (_ctx, _ss) {
                                            if (!_ss.hasData) {
                                              return const SizedBox.shrink();
                                            }
                                            var records = _ss.data ?? [];
                                            var dateFormat =
                                                DateFormat("yyyy/MM/dd");
                                            return ListView.builder(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                right: 5,
                                                bottom: 10,
                                              ),
                                              shrinkWrap: true,
                                              itemCount: records.length,
                                              itemBuilder: (_ctx, idx) {
                                                var createdAt = DateTime.parse(
                                                    records[idx].createdAt ??
                                                        DateTime.now()
                                                            .toIso8601String());
                                                var expiredAt = DateTime.parse(
                                                    records[idx].vipExpiredAt ??
                                                        DateTime.now()
                                                            .toIso8601String());
                                                var isValid = DateTime.now()
                                                        .compareTo(expiredAt) <
                                                    0;
                                                if (isChecked && !isValid) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          width: 26,
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${records[idx].name ?? ''} (${records[idx].remark})',
                                                              maxLines: 2,
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            records[idx]
                                                                        .createdAt
                                                                        ?.isEmpty ==
                                                                    true
                                                                ? const SizedBox
                                                                    .shrink()
                                                                : Text(
                                                                    '開始時間：${dateFormat.format(createdAt)}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          color4,
                                                                    ),
                                                                  ),
                                                            Text(
                                                              '有效時間：${dateFormat.format(expiredAt)}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: color4,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Container(
                                                          width: 60,
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 20),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 3,
                                                            bottom: 3,
                                                            left: 6,
                                                            right: 6,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isValid
                                                                ? color12
                                                                : color15,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          child: Text(
                                                            isValid
                                                                ? '有效'
                                                                : '失效',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        const Center(
                                          child: Text(
                                            '沒有更多紀錄',
                                            style: TextStyle(color: color5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Container(
                                                  width: 120,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: color7,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 16,
                                                    right: 20,
                                                  ),
                                                  child: DropdownButton<int>(
                                                      isExpanded: true,
                                                      icon: VDIcon(
                                                        VIcons.arrow_2_down,
                                                        height: 22,
                                                        width: 22,
                                                      ),
                                                      value: status,
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      // icon: Container(
                                                      //   width: 20,
                                                      //   height: 20,
                                                      //   margin: const EdgeInsets.only(
                                                      //     left: 10,
                                                      //   ),
                                                      //   padding:
                                                      //       const EdgeInsets.all(2),
                                                      //   decoration: BoxDecoration(
                                                      //     borderRadius:
                                                      //         BorderRadius.circular(
                                                      //             2.9),
                                                      //     color: color1,
                                                      //   ),
                                                      //   child: const VDIcon(
                                                      //     VIcons.back_black_2,
                                                      //   ),
                                                      // ),
                                                      items: [0, 1, 2, 3]
                                                          .map(
                                                            (e) =>
                                                                DropdownMenuItem<
                                                                    int>(
                                                              value: e,
                                                              child: Text(
                                                                  e == 0
                                                                      ? '全部'
                                                                      : e == 1
                                                                          ? '確認中'
                                                                          : e ==
                                                                                  2
                                                                              ? '已完成'
                                                                              : '失敗',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                            ),
                                                          )
                                                          .toList(),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          status = val ?? 0;
                                                        });
                                                      }),
                                                )),
                                            Expanded(
                                                flex: 8, child: Container()),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        FutureBuilder<List<Order>>(
                                          future: Get.find<OrderProvider>()
                                              .getManyBy(
                                            userId: user.id,
                                            type: 2,
                                            paymentStatus: status,
                                          ),
                                          builder: (_ctx, _ss) {
                                            if (!_ss.hasData) {
                                              return const SizedBox.shrink();
                                            }
                                            var records = _ss.data ?? [];
                                            return ListView.builder(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 5,
                                                right: 5,
                                                bottom: 10,
                                              ),
                                              shrinkWrap: true,
                                              itemCount: records.length,
                                              itemBuilder: (_ctx, idx) {
                                                var createdAt = DateTime.parse(
                                                    records[idx].createdAt ??
                                                        '');
                                                var record = records[idx];
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    '${record.product?.name ?? ''}/${record.paymentType}'),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  '金額：${NumberFormat.currency(symbol: '').format(DecimalIntl(Decimal.parse(records[idx].orderAmount.toString())))}',
                                                                  maxLines: 2,
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  '訂單時間：${dateFormat.format(createdAt)}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        color4,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '訂單編號：${records[idx].id}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        color4,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Container(
                                                          width: 60,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 20,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 1,
                                                            bottom: 2,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: record
                                                                        .paymentStatus ==
                                                                    1
                                                                ? color7
                                                                : record.paymentStatus ==
                                                                        2
                                                                    ? color12
                                                                    : color15,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          child: Text(
                                                            record.paymentStatus ==
                                                                    1
                                                                ? '確認中'
                                                                : record.paymentStatus ==
                                                                        2
                                                                    ? '已完成'
                                                                    : '失敗',
                                                            style: TextStyle(
                                                              color:
                                                                  record.paymentStatus ==
                                                                          1
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        const Center(
                                          child: Text(
                                            '沒有更多紀錄',
                                            style: TextStyle(color: color5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        ...(isLoading == true
                            ? [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: gs().width,
                                    height: gs().height,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '訂單生成中...',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            : []),
                      ],
                    );
            },
          ),
        ),
        // bottomNavigationBar: widget.refer == 'home'
        //     ? VDBottomNavigationBar(
        //         collection: Get.find<VBaseMenuCollection>(),
        //         activeIndex: Get.find<AppController>().navigationBarIndex,
        //         onTap: Get.find<AppController>().toNamed,
        //       )
        //     : null,
      ),
    );
  }
}
