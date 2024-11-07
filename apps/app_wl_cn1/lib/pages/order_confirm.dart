import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/i18n.dart';
import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';

class OrderConfirmPage extends StatefulWidget {
  final String paymentLink;

  const OrderConfirmPage({super.key, required this.paymentLink});

  @override
  _OrderConfirmPageState createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  bool isOrderPathVisited = false;

  @override
  Widget build(BuildContext context) {
    final bottomNavigatorController = Get.find<BottomNavigatorController>();

    return Scaffold(
      appBar: CustomAppBar(title: I18n.paymentConfirmation),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 30),
              child:
                  Image(image: AssetImage('assets/images/icon-prosessing.png')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                I18n.orderCreatedPaymentPending,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Button(
              text: isOrderPathVisited ? I18n.watchVideo : I18n.goToDeposit,
              onPressed: () async {
                if (!isOrderPathVisited) {
                  await launchUrl(Uri.parse(widget.paymentLink),
                      webOnlyWindowName: '_blank');
                  setState(() {
                    isOrderPathVisited = true;
                  });
                } else {
                  MyRouteDelegate.of(context).pushAndRemoveUntil(
                    AppRoutes.home,
                    hasTransition: false,
                    args: {'defaultScreenKey': HomeNavigatorPathes.layout1},
                  );
                  bottomNavigatorController
                      .changeKey(HomeNavigatorPathes.layout1);
                }
              },
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff21263d),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    I18n.warmHint,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '- 跳转后请及时付款，超时支付无法到账，需要重新发起。\n'
                    '- 每天发起支付不可超过5次，连续发起且未支付，当前账号将会加入黑名单\n'
                    '- 支付通道在夜间较忙碌，为保证您的体验，尽量选择白天支付\n'
                    '- 当选择支付方式无法支付时，请切换不同支付方式尝试',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
