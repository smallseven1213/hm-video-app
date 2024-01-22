import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

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
            int start = index * 5; // 每一行開始的索引
            int end = min(start + 5, items.length); // 每一行結束的索引
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index == (items.length ~/ 5) - 1 ? 15 : 0),
              child: SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // 每一行物件之間的間距
                  children: List.generate(
                    5, // 生成五個物件，包括占位符
                    (i) {
                      int itemIndex = start + i; // 計算當前物件的索引
                      if (itemIndex < end) {
                        // 如果當前索引在資料範圍內，則顯示相應的物件
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              dynamic idDynamic = items[itemIndex].id;
                              int id;
                              if (idDynamic is String) {
                                id = int.parse(idDynamic);
                              } else if (idDynamic is int) {
                                id = idDynamic;
                              } else {
                                throw 'Invalid data type for id';
                              }
                              AdsApi().addBannerClickRecord(id);
                              String urlString = items[itemIndex].url;
                              Uri url = Uri.parse(urlString);
                              launchUrl(url);
                            },
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 物件置中
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SidImage(
                                    sid: items[itemIndex].photoSid,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  items[itemIndex].name,
                                  style: const TextStyle(color: Colors.white),
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
          childCount: (items.length / 5).ceil(), // 每一行5個物件，因此總行數為物件數除以5然後向上取整
        ),
      ),
    );
  }
}
