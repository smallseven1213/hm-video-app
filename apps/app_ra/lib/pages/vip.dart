import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/product.dart';
import 'package:shared/modules/user/user_product_consumer.dart';
import 'package:shared/widgets/sid_image.dart';

import '../config/colors.dart';
import '../screens/coin/payment_list.dart';
import '../utils/show_modal_bottom_sheet.dart';
import '../widgets/custom_app_bar.dart';

Widget _buildProductCard(context, Product product) {
  return Container(
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: SidImage(
                sid: product.photoSid ?? '',
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  product.name ?? '',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  product.subTitle ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.description ?? '',
                maxLines: 2,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12,
                  color: AppColors.colors[ColorKeys.textPrimary]!,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.discount}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colors[ColorKeys.textPrimary]!,
                  ),
                ),
                Text(
                  '原價: ${product.fiatMoneyPrice}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'VIP',
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ProductConsumer(
                type: ProductType.vip.index,
                child: (products) {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => showCustomModalBottomSheet(
                          context,
                          child: PaymentList(
                            productId: product.id ?? 0,
                            amount: product.discount ?? 0,
                            name: product.name,
                          ),
                        ),
                        child: _buildProductCard(context, product),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
