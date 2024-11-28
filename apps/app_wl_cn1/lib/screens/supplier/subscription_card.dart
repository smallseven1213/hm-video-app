import 'package:flutter/material.dart';
import 'package:shared/models/product.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../localization/i18n.dart';
import '../../utils/show_modal_bottom_sheet.dart';
import '../vip/payment_list.dart';

class SubscriptionCard extends StatelessWidget {
  final Product subscription;

  const SubscriptionCard({Key? key, required this.subscription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLimited = subscription.isPromotion ?? false;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => showCustomModalBottomSheet(
            context,
            child: SafeArea(
              child: PaymentList(
                productId: subscription.id ?? 0,
                amount: subscription.discount ?? 0,
                name: subscription.name,
              ),
            ),
          ),
          child: Row(
            children: [
              // 左側紫色背景區域
              Expanded(
                flex: 2,
                child: Container(
                  color: Color.fromARGB(255, 106, 106, 220), // 深紫色背景
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 產品名稱
                      Text(
                        subscription.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // 產品描述
                      Text(
                        subscription.subTitle ?? '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              
              // 右側灰色背景區域
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFF2C2C2C), // 深灰色背景
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 縮小的圖片
                      SizedBox(
                        width: screenWidth * 0.2,
                        height: screenWidth * 0.2,
                        child: SidImage(
                          sid: subscription.photoSid!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // 原價和特價
                      Column(
                        children: [
                          Text(
                            '${I18n.sellingPrice}：${subscription.fiatMoneyPrice}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            '特價：${subscription.discount ?? 0}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
