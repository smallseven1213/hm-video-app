import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_product_consumer.dart';

import '../../localization/i18n.dart';
import 'coin_product_card.dart';

class CoinProductList extends StatelessWidget {
  const CoinProductList({Key? key}) : super(key: key);

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
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: const BoxDecoration(
              color: Color(0xff1c202f),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: ProductConsumer(
              type: ProductType.coin.index,
              child: (products) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: products.map((product) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 24) / 2,
                        child: CoinProductCard(product: product),
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
