import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/game_list/list_view/game_list_item.dart';
import 'package:game/screens/lobby/game_list/list_view/game_list_view_builder.dart';
import 'package:game/screens/lobby/game_list/platform_filter/index.dart';
import 'package:game/screens/lobby/game_list/vertical_filter/index.dart';
import 'package:game/utils/handle_game_item.dart';
import 'package:game/utils/loading.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/utils/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

class GameListView extends StatefulWidget {
  const GameListView({
    Key? key,
  }) : super(key: key);
  @override
  GameListViewState createState() => GameListViewState();
}

class GameListViewState extends State<GameListView>
    with SingleTickerProviderStateMixin {
  GamesListController gamesListController = Get.find<GamesListController>();
  var filteredGameCategories = [];
  List gameHistoryList = [];
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();
  StreamSubscription<String>? eventBusSubscription;
  int selectedPlatformIndex = 0; // 用於跟踪選中的平台

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        selectedPlatformIndex = prefs.getInt('selectedPlatformIndex') ?? 0;
        gamesListController.setGameTypeIndex(0);
        gamesListController.setGamePlatformTpCode(null);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleOpenThirdPartyGame();
      _filterGameCategories();
      _getGameHistory();
    });

    eventBusSubscription = eventBus.onEvent.listen((event) {
      if (event == 'openGame') {
        _handleOpenThirdPartyGame();
      }
    });
  }

  @override
  void dispose() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('selectedPlatformIndex', selectedPlatformIndex);
    });
    eventBusSubscription?.cancel();
    super.dispose();
  }

  _handleOpenThirdPartyGame() {
    logger.i(
        ' ===> OpenThirdPartyGame: ${gameConfigController.thirdPartyGameId.value.isNotEmpty}');
    GameLocalizations localizations = GameLocalizations.of(context)!;
    try {
      if (gameConfigController.isOpenThirdPartyGame.value == true) {
        // 從 gamesListController.games中找到對應gameConfigController.gameId的game
        final openGame = gamesListController.games.firstWhere((element) =>
            element.gameId == gameConfigController.thirdPartyGameId.value &&
            element.tpCode == gameConfigController.thirdPartyGameTpCode.value);
        if (openGame.gameId != '') {
          handleGameItem(context,
              gameId: openGame.gameId,
              updateGameHistory: _getGameHistory,
              tpCode: openGame.tpCode,
              direction: openGame.direction,
              gameType: openGame.gameType);
        }
        gameConfigController.setThirdPartyGame(false, '', '');
      }
    } catch (e) {
      // 打印發生異常的訊息
      logger.e('Exception occurred while trying to open third party game: $e');

      showConfirmDialog(
        context: context,
        title: '',
        content: localizations.translate('game_maintenance_in_progress'),
        onConfirm: () async {
          Navigator.pop(context);
        },
      );
      gameConfigController.setThirdPartyGame(false, '', '');
    }
  }

  _getGameHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> gameHistoryList = prefs.getStringList('gameHistory') ?? [];

    dynamic filteredGameList;
    if (gamesListController.games.isNotEmpty) {
      filteredGameList = gameHistoryList.map((gameId) {
        return gamesListController.games
            .firstWhere((game) => game.gameId.toString() == gameId.toString());
      });
    }
    if (gameHistoryList.isNotEmpty && filteredGameList != null) {
      setState(() {
        this.gameHistoryList = filteredGameList.toList(growable: false);
      });
    }

    logger.i('lobby gameHistoryList: $gameHistoryList');
  }

  // 寫一個篩選遊戲類別的方法
  Future<void> _filterGameCategories() async {
    if (mounted) {
      final GameLocalizations localizations = GameLocalizations.of(context)!;

      List gameCategoriesMapper = [
        {
          'name': localizations.translate('hot'),
          'gameType': -2,
          'icon': 'packages/game/assets/images/game_lobby/menu-hot@3x.webp',
        },
        {
          'name': localizations.translate('fish'),
          'gameType': 1,
          'icon': 'packages/game/assets/images/game_lobby/menu-fish@3x.webp',
        },
        {
          'name': localizations.translate('live'),
          'gameType': 2,
          'icon': 'packages/game/assets/images/game_lobby/menu-live@3x.webp',
        },
        {
          'name': localizations.translate('card'),
          'gameType': 3,
          'icon': 'packages/game/assets/images/game_lobby/menu-poker@3x.webp',
        },
        {
          'name': localizations.translate('slots'),
          'gameType': 4,
          'icon': 'packages/game/assets/images/game_lobby/menu-slot@3x.webp',
        },
        {
          'name': localizations.translate('sports'),
          'gameType': 5,
          'icon': 'packages/game/assets/images/game_lobby/menu-sport@3x.webp',
        },
        {
          'name': localizations.translate('lottery'),
          'gameType': 6,
          'icon': 'packages/game/assets/images/game_lobby/menu-lottery@3x.webp',
        }
      ];

      Set<int> gameTypes = <int>{};

      for (var game in gamesListController.games) {
        gameTypes.add(game.gameType);
      }

      // 將gameTypes轉換為Set<int>型態，以便使用contains方法進行比較

      var filteredCategories = gameCategoriesMapper
          .where((category) =>
              gameTypes.contains(category['gameType']) ||
              category['gameType'] == -2)
          .toList();

      setState(() => filteredGameCategories = filteredCategories);
    } else {
      logger.i('The widget is not mounted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (gamesListController.games.isEmpty) {
        return const GameLoading();
      } else {
        return gamesListController.games.isNotEmpty
            ? Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 10,
                      height: 36,
                      child: PlatformFilter(
                        selectedPlatformIndex: selectedPlatformIndex,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        // 向上靠齊
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 54,
                            child: VerticalFilter(
                              filteredGameCategories: filteredGameCategories,
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                            width: 10,
                            color: Colors.transparent,
                          ),
                          Expanded(
                            child: GameListViewBuilder(
                              filteredGameCategories: filteredGameCategories,
                              buildGameList: _buildGameList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const GameLoading();
      }
    });
  }

  List _getFilteredGameList({
    required int gameType,
    String? tpCode,
  }) {
    var filteredTpCodeGames = tpCode != null && tpCode.isNotEmpty
        ? gamesListController.games
            .where((game) => game.tpCode == tpCode)
            .toList()
        : gamesListController.games;

    // 然後根據遊戲類型進一步過濾
    switch (gameType) {
      case 0: // 假設 0 代表"全部"
        return filteredTpCodeGames;
      case -2: // 熱門遊戲
        return filteredTpCodeGames.where((game) => game.tagId == '2').toList()
          ..sort((a, b) => b.hotOrderIndex.compareTo(a.hotOrderIndex));
      case -1: // 最近玩過的遊戲
        return gameHistoryList.isNotEmpty ? gameHistoryList : [];

      default: // 特定遊戲類型
        return filteredTpCodeGames
            .where((game) => game.gameType == gameType)
            .toList();
    }
  }

  Widget _buildGameList({
    required int gameType,
    String? tpCode,
  }) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    List gameListResult =
        _getFilteredGameList(gameType: gameType, tpCode: tpCode);

    if (gameListResult.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'packages/game/assets/images/game_lobby/game-item-empty-$theme.webp',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 12),
            Text(
              localizations.translate('no_record'),
              style: TextStyle(color: gameLobbyLoginFormColor),
            )
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100, // 设置每个项目的最大宽度
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
              childAspectRatio: 90 / 130,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    handleGameItem(
                      context,
                      gameId: gameListResult[index].gameId,
                      updateGameHistory: _getGameHistory,
                      tpCode: gameListResult[index].tpCode,
                      direction: gameListResult[index].direction,
                      gameType: gameListResult[index].gameType,
                    );
                  },
                  child: GameListItem(
                    imageUrl: gameListResult[index].imgUrl,
                    gameType: gameListResult[index].gameType,
                    name: gameListResult[index].name ?? '',
                  ),
                );
              },
              childCount: gameListResult.length,
            ),
          ),
        )
      ],
    );
  }
}
