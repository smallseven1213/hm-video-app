import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/product.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../localization/i18n.dart';
import '../../utils/show_modal_bottom_sheet.dart';
import '../vip/payment_list.dart';

class SubscriptionCard extends StatelessWidget {
  final Product subscription;

  const SubscriptionCard({Key? key, required this.subscription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 90,
      decoration: BoxDecoration(
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
        child: CustomPaint(
          painter: DiagonalSplitPainter(),
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
                // 左側紫色背景
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.transparent, // 透明背景
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
                        const SizedBox(height: 4),
                        // 產品描述
                        Text(
                          subscription.subTitle ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${I18n.sellingPrice}：',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${subscription.fiatMoneyPrice}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              '${I18n.specialOffer}：${subscription.discount ?? 0}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 右側灰色背景
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.transparent, // 透明背景
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 縮小的圖片
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: SidImage(
                            sid: subscription.photoSid!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Text(
                          '60天',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 60,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              I18n.toSubscribe,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiagonalSplitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const purpleGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 146, 146, 235), // 較淺的紫色
        Color.fromARGB(255, 86, 86, 200), // 較深的紫色
      ],
    );

    const grayGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 126, 125, 125), // 較淺的灰色
        Color.fromARGB(255, 64, 63, 63), // 較深的灰色
      ],
    );

    final purplePaint = Paint()
      ..shader = purpleGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final grayPaint = Paint()
      ..shader = grayGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.6, size.height);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    final purplePath = Path();
    purplePath.moveTo(0, 0);
    purplePath.lineTo(size.width * 0.7, 0);
    purplePath.lineTo(size.width * 0.6, size.height);
    purplePath.lineTo(0, size.height);
    purplePath.close();

    canvas.drawPath(purplePath, purplePaint);
    canvas.drawPath(path, grayPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
