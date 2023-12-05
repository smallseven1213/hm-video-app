import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/gift.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:shared/widgets/sid_image.dart';

final liveApi = LiveApi();

class GiftWidget extends StatelessWidget {
  const GiftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Gifts();
          },
        );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/gift_button.webp',
          width: 33,
          height: 33),
    );
  }
}

class Gifts extends StatelessWidget {
  const Gifts({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final giftsController = Get.put(GiftsController());
    return Container(
      height: 366,
      color: Colors.black,
      padding: const EdgeInsets.all(18),
      child: Column(
        // aligh left
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '禮物清單',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'packages/live_ui_basic/assets/images/close_gifts.webp',
                  width: 8,
                  height: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            children: [
              IntrinsicWidth(
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color(0xbdf771b5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 這行是關鍵
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'packages/live_ui_basic/assets/images/rank_diamond.webp',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '12312,1231',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Image.asset(
                        'packages/live_ui_basic/assets/images/amount_add.webp',
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Obx(
              () => CarouselSlider.builder(
                itemCount: (giftsController.gifts.value.length / 8).ceil(),
                itemBuilder: (context, pageIndex, realIndex) {
                  int startIndex = pageIndex * 8;
                  int endIndex =
                      min(startIndex + 8, giftsController.gifts.value.length);
                  var pageItems =
                      giftsController.gifts.value.sublist(startIndex, endIndex);

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 100 / 140,
                    ),
                    physics: NeverScrollableScrollPhysics(), // 禁用GridView内部的滚动
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      var gift = pageItems[index];
                      return GiftItem(gift: gift);
                    },
                  );
                },
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    // 在这里处理页面改变的事件
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GiftItem extends StatelessWidget {
  final Gift gift;
  const GiftItem({Key? key, required this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          var price = double.parse(gift.price);
          var response = await liveApi.sendGift(gift.id, price);
          if (response.code == 200) {
          } else {
            throw Exception(response.data["msg"]);
          }
        } catch (e) {
          print(e);
          // show dialog for error
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LiveImage(
            // base64String: gift.image,
            base64Url:
                "https://cdn.hubeibk.com/live/webp/app_gifts/018c38d8-5088-71ee-8a45-26f87e492309",
          ),
          // Image.network(
          //   // gift.image,
          //   "https://cdn.hubeibk.com/live/webp/app_gifts/018c38d8-5088-71ee-8a45-26f87e492309",
          //   fit: BoxFit.cover,
          //   width: 73,
          //   height: 73,
          // ),
          const SizedBox(height: 10),
          Text(
            gift.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          // height 5
          const SizedBox(height: 5),
          Text(
            gift.price,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
