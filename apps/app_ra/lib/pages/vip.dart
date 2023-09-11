import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/products/product_consumer.dart';
import 'package:shared/widgets/sid_image.dart';

import '../config/colors.dart';
import '../widgets/my_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'VIP',
      ),
      body: Container(
          padding: const EdgeInsets.all(8),
          child: ProductConsumer(
            type: 2,
            child: (products) {
              print('products: $products');
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

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
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors
                                        .colors[ColorKeys.textPrimary]!,
                                  ),
                                ),
                                Text(
                                  product.subTitle ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors
                                        .colors[ColorKeys.textPrimary]!,
                                  ),
                                )
                              ],
                            )
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
                                  color:
                                      AppColors.colors[ColorKeys.textPrimary]!,
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
                                    color: AppColors
                                        .colors[ColorKeys.textPrimary]!,
                                  ),
                                ),
                                Text(
                                  '原價: ${product.fiatMoneyPrice}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors
                                        .colors[ColorKeys.textPrimary]!,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
