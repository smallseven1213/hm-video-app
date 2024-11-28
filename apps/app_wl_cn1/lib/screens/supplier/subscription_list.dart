import 'package:flutter/material.dart';
import 'package:shared/modules/supplier/supplier_subscription.dart';

import '../../localization/i18n.dart';
import 'subscription_card.dart';

class SubscriptionList extends StatelessWidget {
  const SubscriptionList({Key? key}) : super(key: key);

  Widget _buildWarningSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Text('${I18n.subscriptionValidityPeriod} : ',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(I18n.notSubscribed,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 96, 96, 214),
                          fontSize: 12))
                ],
              )),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              color: Color(0xff0f1320),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: SupplierSubscription(
              type: ProductType.coin.index,
              child: (subscription) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: subscription.map((subscription) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 24),
                        child: SubscriptionCard(subscription: subscription),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          _buildWarningSection(),
        ],
      ),
    );
  }
}
