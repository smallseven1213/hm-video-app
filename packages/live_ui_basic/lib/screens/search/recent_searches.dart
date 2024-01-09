import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_search_history_controller.dart';

import '../../pages/search.dart';

class RecentSearches extends StatelessWidget {
  final searchHistoryController = Get.find<LiveSearchHistoryController>();
  final Function(String)? onSearch;

  RecentSearches({
    Key? key,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => searchHistoryController.searchHistory.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: '最近搜尋'),
                Wrap(
                  direction: Axis.horizontal, // 標籤的排列方向
                  spacing: 8, // 標籤之間的水平間距
                  runSpacing: 8, // 標籤之間的垂直間距
                  children: searchHistoryController.searchHistory
                      .map((tag) => InkWell(
                            onTap: () {
                              Get.find<LiveSearchHistoryController>().add(tag);
                              onSearch!(tag);
                            },
                            child: Container(
                              height: 26,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 3),
                              decoration: const BoxDecoration(
                                  color: Color(0xFF343b4f),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                tag,
                                style:
                                    const TextStyle(color: Color(0xFF6f6f79)),
                              ),
                            ),
                          ))
                      .toList()
                      .cast<Widget>(),
                ),
                // Wrap(
              ],
            )
          : const SizedBox(),
    );
  }
}
