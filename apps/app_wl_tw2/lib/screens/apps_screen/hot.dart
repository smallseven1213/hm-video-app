import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/apps/apps_item_button.dart';
import 'package:shared/widgets/sid_image.dart';

import 'package:app_wl_tw2/config/colors.dart';

class HotWidget extends StatelessWidget {
  final List<Ads> items;
  const HotWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            int start = index * 4; // 每一行開始的索引
            int end = min(start + 4, items.length); // 每一行結束的索引
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index == (items.length ~/ 4) - 1 ? 10 : 0),
              child: SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // 每一行物件之間的間距
                  children: List.generate(
                    4, // 生成五個物件，包括占位符
                    (i) {
                      int itemIndex = start + i; // 計算當前物件的索引
                      if (itemIndex < end) {
                        // 如果當前索引在資料範圍內，則顯示相應的物件
                        return Expanded(
                          child: AppsItemButton(
                            id: items[itemIndex].id,
                            url: items[itemIndex].url,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 物件置中
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SidImage(
                                    sid: items[itemIndex].photoSid,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  items[itemIndex].name,
                                  style: TextStyle(
                                      color: AppColors
                                          .colors[ColorKeys.textPrimary]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // 如果當前索引超出資料範圍，則顯示占位符
                        return const Expanded(child: SizedBox.shrink());
                      }
                    },
                  ),
                ),
              ),
            );
          },
          childCount: (items.length / 4).ceil(), // 每一行4個物件，因此總行數為物件數除以4然後向上取整
        ),
      ),
    );
  }
}
