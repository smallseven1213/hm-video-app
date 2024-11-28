import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared/models/product.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../localization/i18n.dart';
import '../../utils/show_modal_bottom_sheet.dart';
import 'payment_list.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLimited = product.isPromotion ?? false;

    return Center(
      // 加入 Center 確保置中
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8), // 移除 horizontal margin
        child: Container(
          // 使用 Container 而不是 SizedBox 以添加 clipBehavior
          width: 290,
          height: 150,
          clipBehavior: Clip.antiAlias, // 添加裁切效果
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildCard(context, isLimited),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isLimited) {
    return InkWell(
      onTap: () => showCustomModalBottomSheet(
        context,
        child: SafeArea(
          child: PaymentList(
            productId: product.id ?? 0,
            amount: product.discount ?? 0,
            name: product.name,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final parentWidth = constraints.maxWidth;
          final parentHeight = constraints.maxHeight;

          return Stack(
            children: [
              SidImage(
                sid: product.photoSid!,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: parentWidth * 0.28,
                top: parentHeight * 0.19,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.subTitle ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLimited)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      I18n.limitedTimeOffer,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: parentWidth * 0.05,
                bottom: parentHeight * 0.12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Text(
                            product.description ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: parentWidth * 0.05,
                bottom: parentHeight * 0.12,
                child: Column(
                  children: [
                    Text(
                      '${I18n.originalPrice}${product.fiatMoneyPrice}',
                      style: const TextStyle(
                        color: Color(0xffe1e1e1),
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${product.discount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
