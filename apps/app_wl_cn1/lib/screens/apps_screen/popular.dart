import 'package:app_wl_cn1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PopularWidget extends StatelessWidget {
  final List<Ads> items;
  const PopularWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  dynamic idDynamic = items[index].id;
                  int id;
                  if (idDynamic is String) {
                    id = int.parse(idDynamic);
                  } else if (idDynamic is int) {
                    id = idDynamic;
                  } else {
                    throw 'Invalid data type for id';
                  }
                  AdsApi().addBannerClickRecord(id);
                  String urlString = items[index].url;
                  Uri url = Uri.parse(urlString);
                  launchUrl(url);
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SidImage(
                          sid: items[index].photoSid,
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].name,
                                  style: TextStyle(
                                    color:
                                        AppColors.colors[ColorKeys.textPrimary],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  items[index].description,
                                  style: TextStyle(
                                    color: AppColors
                                        .colors[ColorKeys.textSecondary],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      // 按鈕
                      Container(
                        width: 60,
                        height: 28,
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: AppColors.colors[ColorKeys.buttonBgPrimary],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: const Center(
                          child: Text(
                            '下載',
                            style: TextStyle(
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
              if (index != items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Divider(
                    height: 1,
                    color: AppColors.colors[ColorKeys.dividerColor],
                  ),
                ),
            ],
          );
        },
        // childCount: snapshot.data.length,
        childCount: items.length,
      ),
    );
  }
}
