import 'package:flutter/material.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/screens/lobby/game_list/vertical_filter/game_scroll_view_tabs.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class VerticalFilter extends StatefulWidget {
  final dynamic filteredGameCategories;

  const VerticalFilter({
    Key? key,
    required this.filteredGameCategories,
  }) : super(key: key);

  @override
  State<VerticalFilter> createState() => _VerticalFilterState();
}

class _VerticalFilterState extends State<VerticalFilter> {
  final ScrollController _scrollController = ScrollController();
  GamesListController gamesListController = Get.find<GamesListController>();
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();

    ever(gamesListController.resetVerticalFilter, (_) {
      if (mounted) {
        setState(() {
          activeIndex = gamesListController.verticalFilterIndex ?? 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToItem(int index) {
    double itemHeight = 60.0; // 假設每個項目的高度是 60.0
    double minScrollExtent = _scrollController.position.minScrollExtent;
    double maxScrollExtent = _scrollController.position.maxScrollExtent;

    // 計算將該項目滾動到捲軸中間的偏移量
    double scrollToOffset = itemHeight * index -
        (_scrollController.position.viewportDimension - itemHeight) / 2;

    // 確保滾動位置在捲軸範圍內
    scrollToOffset = scrollToOffset.clamp(minScrollExtent, maxScrollExtent);

    // 使用 animateTo 將該項目滾動到捲軸中間或最底部或最頂部
    _scrollController.animateTo(
      scrollToOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.filteredGameCategories.length,
      itemBuilder: (context, index) {
        final category = widget.filteredGameCategories[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              activeIndex = index;
              if (gamesListController.gameTypeIndex.value != -1) {
                gamesListController.setGameTypeIndex(category['gameType']);
              }
            });

            _scrollToItem(index);
          },
          child: GameScrollViewTabs(
            text: category['name'].toString(),
            icon: category['icon'].toString(),
            isActive: (gamesListController.gameTypeIndex.value == 0 ||
                        gamesListController.gameTypeIndex.value == -1) &&
                    gamesListController.gamePlatformTpCode.value == null
                ? false
                : activeIndex == index,
          ),
        );
      },
    );
  }
}
