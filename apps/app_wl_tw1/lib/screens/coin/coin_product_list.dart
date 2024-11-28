import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_product_consumer.dart';

import '../../localization/i18n.dart';
import 'coin_product_card.dart';

class CoinProductList extends StatelessWidget {
  const CoinProductList({Key? key}) : super(key: key);

  Widget _buildWarningSection() {
    return Container(
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
            '1.溫馨I18n.hintMessage內容文字區塊，營運端提供內容文案。營運端提供內容文案。可放超連結。\n'
            '1.溫馨I18n.hintMessage內容文字區塊，營運端提供內容文案。營運端提供內容文案。可放超連結。',
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
                        width: (MediaQuery.of(context).size.width - 24) /
                            2,
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
