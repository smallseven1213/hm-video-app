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

class Gifts extends StatefulWidget {
  const Gifts({Key? key}) : super(key: key);

  @override
  _GiftsState createState() => _GiftsState();
}

class _GiftsState extends State<Gifts> {
  final giftsController = Get.find<GiftsController>();
  ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndexNotifier.dispose(); // 釋放資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final giftsController = Get.find<GiftsController>();
    int totalPageCount = (giftsController.gifts.value.length / 8).ceil();
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

                  // 創建一個填充剩餘空間的透明Container
                  Widget transparentContainer = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 73,
                        width: 73,
                      ),
                    ],
                  );

                  // 動態生成小部件列表，包括占位符
                  List<Widget> createGiftRow(int rowStart, int rowEnd) {
                    // 確保行中至少有四個小部件，包括真實的項目和占位符
                    return List<Widget>.generate(4, (index) {
                      // 確定是否應該顯示真實的禮物項目
                      if (rowStart + index < pageItems.length) {
                        // 如果應該顯示禮物項目，則返回一個帶有邊距的禮物項目
                        return Padding(
                          padding: const EdgeInsets.all(4.0), // 調整邊距以符合您的設計
                          child: GiftItem(gift: pageItems[rowStart + index]),
                        );
                      } else {
                        // 如果不顯示禮物項目，則返回一個相同大小的透明容器作為占位符
                        return Padding(
                          padding: const EdgeInsets.all(4.0), // 調整邊距以符合您的設計
                          child: transparentContainer,
                        );
                      }
                    });
                  }

                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: createGiftRow(0, 4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: createGiftRow(4, 8),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    _currentIndexNotifier.value = index;
                  },
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _currentIndexNotifier, // 監聽ValueNotifier
            builder: (context, child) {
              // 這個builder只會重建以下小部件，當_currentIndexNotifier發生變化時
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPageCount, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndexNotifier.value == index
                          ? Colors.white
                          : Colors.grey,
                    ),
                  );
                }),
              );
            },
          ),
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
          const SizedBox(height: 5),
          Text(
            gift.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
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
