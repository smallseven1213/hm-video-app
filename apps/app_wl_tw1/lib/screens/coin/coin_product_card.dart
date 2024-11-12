import 'package:flutter/material.dart';
import 'package:shared/models/product.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../localization/i18n.dart';
import '../../utils/show_modal_bottom_sheet.dart';
import '../vip/payment_list.dart';

class CoinProductCard extends StatelessWidget {
  final Product product;

  const CoinProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLimited = product.isPromotion ?? false;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0f1320),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 限時特價或商品標籤
            isLimited
                ? Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 3),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF0BBC2), Color(0xFFE18AB5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      I18n.limitedTimeOffer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox(height: 20),
            const SizedBox(height: 5),
            // 產品名稱
            Text(
              product.name ?? '',
              style: const TextStyle(
                color: Color(0xffF4CDCA),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            // 圖片
            Expanded(
              child: Center(
                child: SidImage(
                  sid: product.photoSid!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 產品描述
            Text(
              product.subTitle ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // 原價和特價
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 原價
                Text(
                  '${I18n.sellingPrice}：${product.fiatMoneyPrice}',
                  style: TextStyle(
                    color: const Color(0xff919bb3),
                    fontSize: 12,
                    decoration: product.fiatMoneyPrice != null
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                // 特價
                product.balanceFiatMoneyPrice != null
                    ? Text(
                        '${I18n.specialOffer}：${product.balanceFiatMoneyPrice}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      )
                    : const SizedBox(height: 20),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
