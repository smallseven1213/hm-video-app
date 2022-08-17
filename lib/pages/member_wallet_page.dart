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

class MemberWalletPage extends StatefulWidget {
  const MemberWalletPage({Key? key}) : super(key: key);

  @override
  _MemberWalletPageState createState() => _MemberWalletPageState();
}

class _MemberWalletPageState extends State<MemberWalletPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController animationController;
  int status = 0;
  int paymentMethod = 0;
  bool isLoading = false;
  bool paymentOpened = false;
  List<Product> products = [];

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ));
    Get.find<ProductProvider>().getManyBy(type: 1).then((value) {
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
    animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    tabController.animateTo(index);
    setState(() {});
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
              height: (kIsWeb ? 150 : 180) + payments.length * 60,
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
                                  const SizedBox(
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
                          if (kIsWeb) {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            windowRef?.location.href = value;
//                             alertModal(
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
                      child: const Text(
                        '確認支付',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: color1,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: color1,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<User>(
          future: Get.find<UserProvider>().getCurrentUser(),
          builder: (_ctx, _snapshot) {
            var user = _snapshot.data ?? User('', 0, ['guest']);
            // print('reloaded');
            return !_snapshot.hasData
                ? const VDLoading()
                : Stack(
                    children: [
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              backgroundColor: Colors.transparent,
                              toolbarHeight: 0,
                              collapsedHeight: 258,
                              expandedHeight: 258,
                              pinned: true,
                              elevation: 0,
                              flexibleSpace: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: gs().width,
                                    height: 230,
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
                                          // top: 20,
                                          right: 15,
                                          bottom: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                back();
                                              },
                                              enableFeedback: true,
                                              child: Container(
                                                // decoration: BoxDecoration(color: Colors.red),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 20,
                                                ),
                                                child: const Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        -10, 0, 0),
                                                child: const Center(
                                                  child: Text(
                                                    '金幣錢包',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FutureBuilder<String>(
                                              future: AuthProvider.getToken(),
                                              builder: (_cctx, _ssnap) => (!_ssnap
                                                          .hasData ||
                                                      (user.avatar == null ||
                                                          user.avatar
                                                                  ?.isEmpty ==
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
                                                          url:
                                                              // '${AppController.cc.endpoint.getApi()}/public/photos/photo/preview?sid=${user.avatar ?? ''}',
                                                              user.avatar ?? '',
                                                          // width: 60,
                                                          // height: 60,
                                                          headers: {
                                                            'Authorization':
                                                                _ssnap.data ??
                                                                    '',
                                                          },
                                                        ),
                                                      ),
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
                                                              Text(
                                                                  user.nickname ??
                                                                      '')
                                                            ],
                                                          )
                                                        : Text(user.nickname ??
                                                            ''),
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
                                          bottom: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 32,
                                                padding: const EdgeInsets.only(
                                                  top: 9,
                                                  bottom: 5,
                                                  left: 20,
                                                  right: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: color3,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: Text(
                                                    NumberFormat.currency(
                                                            symbol: '\$  ')
                                                        .format(DecimalIntl(
                                                            Decimal.parse(
                                                                user.points ??
                                                                    '0')))),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                animationController.forward();
                                                setState(() {});
                                                Future.delayed(const Duration(
                                                        milliseconds: 1000))
                                                    .then((value) {
                                                  animationController.reset();
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
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: RotationTransition(
                                                  turns: Tween(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                          animationController),
                                                  child: const VDIcon(
                                                      VIcons.reload_black),
                                                ),
                                              ),
                                            ),
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
                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                            // spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(3, -7),
                                          ),
                                        ],
                                      ),
                                      child: IntrinsicHeight(
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
                                                          '金幣包',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                tabController
                                                                            .index ==
                                                                        0
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .normal,
                                                            fontSize: tabController
                                                                        .index ==
                                                                    0
                                                                ? 16
                                                                : 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 9,
                                                      ),
                                                      tabController.index == 0
                                                          ? Divider(
                                                              color: Color(
                                                                  0xffffdc00),
                                                              thickness: 3,
                                                              indent: 46,
                                                              endIndent: 46,
                                                              height: 3)
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(
                                              thickness: 1,
                                              indent: 15,
                                              endIndent: 15,
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
                                                          '消費紀錄',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                tabController
                                                                            .index ==
                                                                        1
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .normal,
                                                            fontSize: tabController
                                                                        .index ==
                                                                    1
                                                                ? 16
                                                                : 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 9,
                                                      ),
                                                      tabController.index == 1
                                                          ? Divider(
                                                              color: Color(
                                                                  0xffffdc00),
                                                              thickness: 3,
                                                              indent: 45,
                                                              endIndent: 45,
                                                              height: 3)
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(
                                              thickness: 1,
                                              indent: 15,
                                              endIndent: 15,
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
                                                            fontWeight:
                                                                tabController
                                                                            .index ==
                                                                        2
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .normal,
                                                            fontSize: tabController
                                                                        .index ==
                                                                    2
                                                                ? 16
                                                                : 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 9,
                                                      ),
                                                      tabController.index == 2
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
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        body: TabBarView(
                          controller: tabController,
                          children: [
                            Container(
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: Column(children: [
                                    FutureBuilder<List<Product>>(
                                      future: Future.value(products),
                                      builder: (_ctx, _ss) {
                                        if (!_ss.hasData) {
                                          return const SizedBox.shrink();
                                        }
                                        return Wrap(
                                          spacing: 12,
                                          direction: Axis.horizontal,
                                          children: (_ss.data ?? [])
                                              .map(
                                                (e) => Container(
                                                  width: (gs().width - 52) / 2,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  margin: const EdgeInsets.only(
                                                      top: 13),
                                                  padding: EdgeInsets.only(
                                                      bottom: e.discount !=
                                                                  null &&
                                                              e.discount! > 0
                                                          ? 16
                                                          : 34),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white,
                                                        color17,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    border: Border.all(
                                                      color: color16,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: InkWell(
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
                                                        (e.subTitle?.isNotEmpty ==
                                                                true)
                                                            ? Center(
                                                                child:
                                                                    Container(
                                                                  width: (gs().width -
                                                                          52) /
                                                                      4,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 1,
                                                                    bottom: 2,
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      begin: Alignment
                                                                          .centerRight,
                                                                      end: Alignment
                                                                          .centerLeft,
                                                                      colors: [
                                                                        color18,
                                                                        color19,
                                                                      ],
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              6.0),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              6.0),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    e.subTitle
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          color20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink(),
                                                        Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 28,
                                                            ),
                                                            Text(
                                                              e.name ?? '',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Container(
                                                              width: 80,
                                                              height: 80,
                                                              // decoration:
                                                              //     BoxDecoration(
                                                              //         image:
                                                              //             DecorationImage(
                                                              //   image: NetworkImage(
                                                              //       e.getProductImageUrl()),
                                                              // )),
                                                              child: VDImage(
                                                                url: e
                                                                    .getProductImageUrl(),
                                                                width: 80,
                                                                height: 80,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              e.description ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        .5),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 25,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  '售價：',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  e.fiatMoneyPrice ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    decoration: e.discount !=
                                                                                null &&
                                                                            e.discount! >
                                                                                0
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : TextDecoration
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            ...(e.discount !=
                                                                        null &&
                                                                    e.discount! >
                                                                        0
                                                                ? [
                                                                    Text(
                                                                      '特價：${NumberFormat.currency(symbol: '').format(DecimalIntl(Decimal.parse('${e.discount ?? 0}')))}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ]
                                                                : []),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 88,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            '溫馨提醒',
                                            style: TextStyle(
                                              color: color2,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '1：支付不成功，請多次嘗試支付。',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: color2,
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
                                              color: color2,
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
                                              color: color2,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    FutureBuilder<List<UserPointRecord>>(
                                      future:
                                          Get.find<PointProvider>().getPoints(),
                                      builder: (_ctx, _ss) {
                                        if (!_ss.hasData) {
                                          return const SizedBox.shrink();
                                        }
                                        var records = _ss.data ?? [];
                                        var fullDateFormat =
                                            DateFormat("yyyy/MM/dd");
                                        var fullTimeFormat =
                                            DateFormat("HH:mm:ss");
                                        return ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: records.length,
                                          itemBuilder: (_ctx, idx) {
                                            var createdAt = DateTime.parse(
                                                records[idx].createdAt ?? '');
                                            // if (status) {
                                            //   return const SizedBox.shrink();
                                            // }
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              fullDateFormat
                                                                  .format(
                                                                      createdAt),
                                                              maxLines: 1,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                            Text(
                                                              fullTimeFormat
                                                                  .format(
                                                                      createdAt),
                                                              maxLines: 1,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          records[idx].name ??
                                                              '',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          NumberFormat.currency(
                                                                  symbol: '')
                                                              .format(DecimalIntl(
                                                                  Decimal.parse(
                                                                      records[idx]
                                                                              .usedPoints ??
                                                                          "0"))),
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
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 32,
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
                                                    BorderRadius.circular(4.0),
                                              ),
                                              margin: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 20,
                                              ),
                                              child: DropdownButton<int>(
                                                  isExpanded: true,
                                                  value: status,
                                                  underline: Container(
                                                    height: 0,
                                                  ),
                                                  iconSize: 22,
                                                  icon: VDIcon(
                                                    VIcons.arrow_2_down,
                                                    height: 22,
                                                    width: 22,
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
                                                        (e) => DropdownMenuItem<
                                                            int>(
                                                          value: e,
                                                          child: Text(
                                                            e == 0
                                                                ? '全部'
                                                                : e == 1
                                                                    ? '確認中'
                                                                    : e == 2
                                                                        ? '已完成'
                                                                        : '失敗',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      status = val ?? 0;
                                                    });
                                                  }),
                                            )),
                                        Expanded(flex: 8, child: Container()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    FutureBuilder<List<Order>>(
                                      future:
                                          Get.find<OrderProvider>().getManyBy(
                                        userId: user.id,
                                        type: 1,
                                        paymentStatus: status,
                                      ),
                                      builder: (_ctx, _ss) {
                                        if (!_ss.hasData) {
                                          return const SizedBox.shrink();
                                        }
                                        var records = _ss.data ?? [];
                                        var dateFormat =
                                            DateFormat("yyyy/MM/dd HH:mm:ss");
                                        return ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: records.length,
                                          itemBuilder: (_ctx, idx) {
                                            var createdAt = DateTime.parse(
                                                records[idx].createdAt ?? '');
                                            var record = records[idx];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
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
                                                                fontSize: 12,
                                                                color: color4,
                                                              ),
                                                            ),
                                                            Text(
                                                              '訂單編號：${records[idx].id}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: color4,
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
                                                          const EdgeInsets.only(
                                                        right: 20,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 1,
                                                        bottom: 2,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
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
                                                                .circular(4.0),
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
                                                                  ? Colors.black
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
                            ),
                          ],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
