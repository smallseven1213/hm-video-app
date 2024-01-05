import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/models/gift.dart';
import 'package:live_core/models/live_api_response_base.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_ui_basic/widgets/live_button.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../../libs/showLiveDialog.dart';
import 'user_diamonds.dart';

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
    final giftsController = Get.find<GiftsController>();
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
              const Text(
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
          const UserDiamonds(),
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

                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GiftItem(gift: pageItems[0]),
                          GiftItem(gift: pageItems[1]),
                          GiftItem(gift: pageItems[2]),
                          GiftItem(gift: pageItems[3]),
                        ],
                      ),
                      // height 10
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GiftItem(gift: pageItems[4]),
                          GiftItem(gift: pageItems[5]),
                          GiftItem(gift: pageItems[6]),
                          GiftItem(gift: pageItems[7]),
                        ],
                      ),
                    ],
                  );

                  // return GridView.builder(
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 4,
                  //     childAspectRatio: 100 / 110,
                  //   ),
                  //   physics:
                  //       const NeverScrollableScrollPhysics(), // 禁用GridView内部的滚动
                  //   itemCount: pageItems.length,
                  //   itemBuilder: (context, index) {
                  //     var gift = pageItems[index];
                  //     return GiftItem(gift: gift);
                  //   },
                  // );
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
    bool arrowSend = true;
    return InkWell(
      onTap: () async {
        if (arrowSend) {
          try {
            var price = double.parse(gift.price);
            var userAmount = Get.find<LiveUserController>().getAmount;
            if (userAmount < price) {
              showLiveDialog(
                context,
                title: '鑽石不足',
                content: Center(
                  child: Text('鑽石不足，請前往充值',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                actions: [
                  LiveButton(
                      text: '取消',
                      type: ButtonType.secondary,
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  LiveButton(
                      text: '確定',
                      type: ButtonType.primary,
                      onTap: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            } else {
              LiveApiResponseBase<bool> response =
                  await liveApi.sendGift(gift.id, price);
              if (response.code == 200) {
                Get.find<LiveUserController>().getUserDetail();
              } else {
                throw Exception(response.data);
              }
              Navigator.of(context).pop();
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
          } finally {
            arrowSend = true;
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 73,
            width: 73,
            // radius 10
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: LiveImage(
              base64Url: gift.image,
              fit: BoxFit.cover,
            ),
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
          const SizedBox(height: 3),
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
