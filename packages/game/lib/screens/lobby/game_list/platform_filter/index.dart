import 'package:flutter/material.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'chip.dart';

final logger = Logger();

class PlatformFilter extends StatefulWidget {
  final int selectedPlatformIndex;

  const PlatformFilter({
    Key? key,
    required this.selectedPlatformIndex,
  }) : super(key: key);

  @override
  State<PlatformFilter> createState() => _PlatformFilterState();
}

class _PlatformFilterState extends State<PlatformFilter> {
  GamesListController gamesListController = Get.find<GamesListController>();
  final ScrollController _horizontalScrollController = ScrollController();
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.selectedPlatformIndex;
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedChip(int index) {
    double itemWidth = 80.0; // 估計每個 chip 的寬度，可以根據實際情況調整
    double minScrollExtent =
        _horizontalScrollController.position.minScrollExtent;
    double maxScrollExtent =
        _horizontalScrollController.position.maxScrollExtent;
    double viewportWidth =
        _horizontalScrollController.position.viewportDimension;

    // 計算將該項目滾動到視窗中間的偏移量
    double scrollToOffset = itemWidth * index - (viewportWidth - itemWidth) / 2;

    // 確保滾動位置在捲軸範圍內
    scrollToOffset = scrollToOffset.clamp(minScrollExtent, maxScrollExtent);

    // 使用 animateTo 將該項目滾動到視窗中間或最左側或最右側
    _horizontalScrollController.animateTo(
      scrollToOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    List<Widget> chips = [
      // 「全部」選項
      buildChip(
        label: localizations.translate('all'),
        selected: activeIndex == 0,
        onSelected: () {
          _scrollToSelectedChip(0);
          setState(() {
            activeIndex = 0;
            gamesListController.setGameTypeIndex(0);
            gamesListController.setGamePlatformTpCode(null);
            gamesListController.triggerVerticalFilterReset();
            gamesListController.setVerticalFilterIndex(null);
          });
        },
        avatar: Image.asset(
            'packages/game/assets/images/game_lobby/menu-all@3x.webp'),
      ),
      // 「最近」選項
      buildChip(
        label: localizations.translate('recent'),
        selected: activeIndex == 1,
        onSelected: () {
          _scrollToSelectedChip(1);
          setState(() {
            activeIndex = 1;
            gamesListController.setGameTypeIndex(-1);
            gamesListController.setGamePlatformTpCode(null);
            gamesListController.triggerVerticalFilterReset();
            gamesListController.setVerticalFilterIndex(null);
          });
        },
        avatar: Image.asset(
            'packages/game/assets/images/game_lobby/menu-new@3x.webp'),
      ),
    ];

    // 添加平台選項
    chips.addAll(
        gamesListController.gamePlatformList.value.asMap().entries.map((entry) {
      final index = entry.key + 2; // 因為已經有兩個固定選項，所以索引要加2
      final platform = entry.value;
      return buildChip(
          label: platform.gamePlatformName,
          selected: activeIndex == index,
          avatar: Image.network(platform.logo ?? ''),
          onSelected: () {
            _scrollToSelectedChip(index);
            setState(() {
              activeIndex = index;
              gamesListController.setGameTypeIndex(-2);
              gamesListController.setGamePlatformTpCode(platform.tpCode);
              gamesListController.triggerVerticalFilterReset();
              gamesListController.setVerticalFilterIndex(0);
            });
          });
    }));

    return SingleChildScrollView(
      controller: _horizontalScrollController,
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }
}
