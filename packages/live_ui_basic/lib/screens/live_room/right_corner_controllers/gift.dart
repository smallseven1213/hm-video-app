import 'dart:async';
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
import 'package:live_core/widgets/room_payment_check.dart';
import 'package:live_ui_basic/widgets/live_button.dart';

import '../../../libs/goto_deposit.dart';
import '../../../libs/show_live_dialog.dart';
import '../../../localization/live_localization_delegate.dart';
import '../../../widgets/x_count.dart';
import 'user_diamonds.dart';

final liveApi = LiveApi();

class GiftWidget extends StatelessWidget {
  final int pid;
  const GiftWidget({Key? key, required this.pid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoomPaymentCheck(
        pid: pid,
        child: (bool hasPermission) {
          if (hasPermission) {
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const Gifts();
                  },
                );
              },
              child: Image.asset(
                  'packages/live_ui_basic/assets/images/gift_button.webp',
                  width: 33,
                  height: 33),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class Gifts extends StatefulWidget {
  const Gifts({Key? key}) : super(key: key);

  @override
  GiftsState createState() => GiftsState();
}

class GiftsState extends State<Gifts> {
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
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

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
              Text(
                localizations.translate('gift_list'),
                style: const TextStyle(
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
                  Widget transparentContainer = const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
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
            animation: _currentIndexNotifier,
            builder: (context, child) {
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

class GiftItem extends StatefulWidget {
  final Gift gift;

  const GiftItem({Key? key, required this.gift}) : super(key: key);

  @override
  GiftItemState createState() => GiftItemState();
}

class GiftItemState extends State<GiftItem>
    with SingleTickerProviderStateMixin {
  ValueNotifier<int> clickCount = ValueNotifier(0);
  Timer? debounceTimer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150), // 动画持续时间
      vsync: this,
    );
  }

  @override
  void dispose() {
    debounceTimer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  void handleTap() {
    _animationController
      ..reset() // 重置动画
      ..forward();
    clickCount.value += 1; // Increment click count on every tap

    if (debounceTimer?.isActive ?? false) {
      debounceTimer!.cancel(); // Cancel existing timer if it's active
    }

    // Start a new timer
    debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        var price = double.parse(widget.gift.price);
        var totalPrice = price * clickCount.value;
        var userAmount = Get.find<LiveUserController>().getAmount;
        if (userAmount < totalPrice) {
          // If insufficient funds, show dialog and reset count
          showInsufficientFundsDialog(context);
        } else {
          LiveApiResponseBase<bool> response =
              await liveApi.sendGift(widget.gift.id, price, clickCount.value);
          if (response.code == 200) {
            Get.find<LiveUserController>().getUserDetail();
          } else {
            return;
            // throw Exception(response.data);
          }
        }
      } finally {
        clickCount.value = 0; // Reset click count
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        InkWell(
          onTap: handleTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 63,
                width: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: LiveImage(
                  base64Url: widget.gift.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.gift.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Text(
                widget.gift.price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: clickCount,
          builder: (context, value, child) {
            if (value > 1) {
              return XCountWidget(count: value);
            } else {
              return const SizedBox.shrink(); // 当clickCount <= 1时不显示任何内容
            }
          },
        ),
      ],
    );
  }

  void showInsufficientFundsDialog(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    showLiveDialog(
      context,
      title: localizations.translate('not_enough_diamonds'),
      content: Center(
        child: Text(
            localizations.translate('insufficient_diamonds_please_recharge'),
            style: const TextStyle(color: Colors.white, fontSize: 11)),
      ),
      actions: [
        LiveButton(
            text: localizations.translate('cancel'),
            type: ButtonType.secondary,
            onTap: () {
              Navigator.of(context).pop();
            }),
        LiveButton(
            text: localizations.translate('confirm'),
            type: ButtonType.primary,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              gotoDeposit();
            })
      ],
    );
  }
}
