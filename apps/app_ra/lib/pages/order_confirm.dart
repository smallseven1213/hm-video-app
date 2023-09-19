import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

import '../config/colors.dart';
import '../widgets/button.dart';
import '../widgets/my_app_bar.dart';

class OrderConfirmPage extends StatelessWidget {
  const OrderConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: '付款確認中'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Text(
              '訂單已建立，付款確認中...',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            width: 120,
            child: Button(
              text: '去看片',
              onPressed: () =>
                  MyRouteDelegate.of(context).push(AppRoutes.home),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.colors[ColorKeys.primary]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '溫韾提示',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colors[ColorKeys.textPrimary]!,
                    ),
                  ),
                  const Text(
                    '內文內文內文內文內文內文內文內文內文內文內文內文內文內文',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
