import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/apps/apps_item_button.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../config/colors.dart';

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
              AppsItemButton(
                id: items[index].id,
                url: items[index].url,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color:
                                        AppColors.colors[ColorKeys.textPrimary],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      // 按鈕
                      Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                            color: Color(0xFFfe2c55),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Center(
                          child: Text(
                            I18n.downloadNow,
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
