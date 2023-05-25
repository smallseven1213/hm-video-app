// HotWidget is a stateless widget, has FutureBuilder to get AdsApi.getManyBy

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

class HotWidget extends StatelessWidget {
  const HotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdsApi().getRecommendBy(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                int start = index * 5; // 每一行開始的索引
                int end = min(start + 5, snapshot.data.length); // 每一行結束的索引
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0), // 每一行的底部間距
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
                            child: InkWell(
                              onTap: () {
                                dynamic idDynamic = snapshot.data[itemIndex].id;
                                int id;
                                if (idDynamic is String) {
                                  id = int.parse(idDynamic);
                                } else if (idDynamic is int) {
                                  id = idDynamic;
                                } else {
                                  throw 'Invalid data type for id';
                                }
                                AdsApi().addBannerClickRecord(id);
                                String urlString = snapshot.data[itemIndex].url;
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
                                      sid: snapshot.data[itemIndex].photoSid,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    snapshot.data[itemIndex].name,
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // 如果當前索引超出資料範圍，則顯示占位符
                          return Expanded(child: SizedBox.shrink());
                        }
                      },
                    ),
                  ),
                );
              },
              childCount: (snapshot.data.length / 5)
                  .ceil(), // 每一行5個物件，因此總行數為物件數除以5然後向上取整
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
