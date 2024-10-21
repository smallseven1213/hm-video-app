import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/models/product.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/modules/user/user_product_consumer.dart';
import 'package:shared/widgets/sid_image.dart';

import '../screens/vip/payment_list.dart';
import '../utils/show_modal_bottom_sheet.dart';
import '../widgets/avatar.dart';
import '../widgets/custom_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({super.key});

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: UserInfoV2Consumer(
        child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
          return Row(
            children: [
              Avatar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${info.uid}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWarningSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff21263d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '溫馨提示',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '1.溫馨提示內容文字區塊，營運端提供內容文案。營運端提供內容文案。可放超連結。',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '2.溫馨提示內容文字區塊，營運端提供內容文案。營運端提供內容文案。可放超連結。',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff1c202f),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('VIP', isSelected: true),
          _buildTab('特權記錄'),
          _buildTab('存款記錄'),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {bool isSelected = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.pink[100] : Colors.grey,
              fontSize: 16,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 2,
              color: Colors.pink[100],
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final bool isLimited = product.isPromotion ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 42, vertical: 8),
      child: AspectRatio(
        aspectRatio: 290 / 150,
        child: InkWell(
          onTap: () => showCustomModalBottomSheet(
            context,
            child: PaymentList(
              productId: product.id ?? 0,
              amount: product.discount ?? 0,
              name: product.name,
            ),
          ),
          //
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
                    left: parentWidth * .28,
                    top: parentHeight * 19 / 100,
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
                          product.description ?? '',
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
                        child: const Text(
                          '限時特價',
                          style: TextStyle(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Text(
                                '${product.vipDays}天VIP 視頻免費看',
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
                          '原價: ¥${product.fiatMoneyPrice}',
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1320),
      appBar: const CustomAppBar(title: 'VIP會員'),
      body: Column(
        children: [
          // User Profile Section
          _buildUserInfo(),
          // Tab Section
          _buildTabBar(),
          // Product Cards Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff1c202f),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: ProductConsumer(
                type: ProductType.vip.index,
                child: (products) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length, // +1 for warning section
                      itemBuilder: (context, index) {
                        return _buildProductCard(context, products[index]);
                      });
                },
              ),
            ),
          ),
          _buildWarningSection(),
        ],
      ),
    );
  }
}
