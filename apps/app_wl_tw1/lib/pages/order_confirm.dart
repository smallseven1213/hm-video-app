import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

import '../config/colors.dart';
import '../localization/i18n.dart';
import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';

class OrderConfirmPage extends StatelessWidget {
  const OrderConfirmPage({super.key});

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
              padding: EdgeInsets.fromLTRB(0,60,0,30),
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
              text: I18n.watchVideo,
              onPressed: () => {
                MyRouteDelegate.of(context).pushAndRemoveUntil(
                  AppRoutes.home,
                  hasTransition: false,
                  args: {'defaultScreenKey': HomeNavigatorPathes.layout1},
                ),
                bottomNavigatorController.changeKey(HomeNavigatorPathes.layout1)
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
                    '1.溫馨提示內容文字區塊，營運端提供內容文案。營運端提供內容文案。可放超連結。',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2.溫馨提示內容文字區塊，營運端提供內容文案。營運端提供內容文案。可放超連結。',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
