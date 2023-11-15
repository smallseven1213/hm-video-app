import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/models/game_list.dart';
import 'package:game/utils/handle_game_item.dart';
import 'package:game/utils/loading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/game_localization_delegate.dart';
import '../../widgets/cache_image.dart';
import 'game_scroll_view_tabs.dart';

final logger = Logger();

class GameListItem extends StatelessWidget {
  final String imageUrl;
  final int gameType;

  const GameListItem({Key? key, required this.imageUrl, required this.gameType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color.fromRGBO(0, 0, 0, .10),
        //     offset: Offset(0.5, 0.5),
        //     spreadRadius: 1.5,
        //     blurRadius: 5.0,
        //   ),
        // ],
      ),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: imageUrl != '' || imageUrl.isNotEmpty
              ? Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: gameLobbyEmptyColor,
                    ),
                    kIsWeb
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : CacheImage(
                            url: imageUrl,
                            width: double.infinity,
                            height:
                                (MediaQuery.of(context).size.width - 110) / 3,
                            fit: BoxFit.cover,
                            emptyImageUrl:
                                'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                          )
                  ],
                )
              // CacheImage(
              //     url: imageUrl,
              //     width: double.infinity,
              //     height: (Get.width - 110) / 3,
              //     fit: BoxFit.cover,
              //     emptyImageUrl:
              //         'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
              //   )
              : SizedBox(
                  child: Image.asset(
                    'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                    width: double.infinity,
                    height: 105,
                  ),
                ),
        ),
      ),
    );
  }
}

class GameListView extends StatefulWidget {
  const GameListView({
    Key? key,
  }) : super(key: key);
  @override
  GameListViewState createState() => GameListViewState();
}

class GameListViewState extends State<GameListView>
    with SingleTickerProviderStateMixin {
  final GamesListController gamesListController =
      Get.put(GamesListController());
  var filteredGameCategories = [];
  List gameHistoryList = [];
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    gamesListController.fetchGames().then((value) {
      _filterGameCategories();
      _getGameHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getGameHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> gameHistoryList = prefs.getStringList('gameHistory') ?? [];

    // 宣告一個filter過的list
    // gameHistoryList中的gameId如果在gameListFromController中有的話，就把gameListFromController中的資料塞進去
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
  _filterGameCategories() {
    Set<int> gameTypes = <int>{};

    for (var game in gamesListController.games) {
      gameTypes.add(game.gameType);
    }

    // 將gameTypes轉換為Set<int>型態，以便使用contains方法進行比較

    var filteredCategories = gameCategoriesMapper
        .where((category) =>
            gameTypes.contains(category['gameType']) ||
            category['gameType'] == 0 ||
            category['gameType'] == -1)
        .toList();

    // 將過濾後的遊戲類別列表分配給filteredGameCategories

    filteredGameCategories.assignAll(filteredCategories);
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
    return Obx(() {
      if (gamesListController.games.isEmpty) {
        return const GameLoading();
      } else {
        return gamesListController.games.isNotEmpty
            ? Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 54,
                      child: ListView.builder(
                        controller:
                            _scrollController, // Assign the scroll controller
                        shrinkWrap: true,
                        itemCount: filteredGameCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredGameCategories[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                              _scrollToItem(index);
                            },
                            child: GameScrollViewTabs(
                              text: category['name'].toString(),
                              icon: category['icon'].toString(),
                              isActive: _currentIndex == index,
                            ),
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(
                        thickness: 1, width: 10, color: Colors.transparent),
                    Expanded(
                      child: IndexedStack(
                        index: _currentIndex,
                        children: filteredGameCategories.map((category) {
                          final gameType = category['gameType'] as int;
                          return gamesListController.games.isNotEmpty
                              ? _buildGameList(gameType)
                              : const SizedBox();
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              )
            : const GameLoading();
      }
    });
  }

  Widget _buildGameList(int gameType) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    final gameListResult = gameType == 0
        ? gamesListController.games
        : gameHistoryList.isNotEmpty && gameType == -1
            ? gameHistoryList
            : gamesListController.games
                .where((game) => game.gameType == gameType)
                .toList()
                .obs;
    // final totalItemCount = gameListResult.length.isOdd
    //     ? (gameListResult.length ~/ 2) + 1 // 如果是奇數就加1
    //     : gameListResult.length ~/ 2;

    return gameListResult.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 600 / 400,
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
                      ),
                    );
                  },
                  childCount: gameListResult.length,
                ),
              )
            ],
          )
        : Center(
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
}
