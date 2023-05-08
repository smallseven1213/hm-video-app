import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/game_scroll_view_tabs.dart';
import 'package:game/widgets/cache_image.dart';

class GameListItem extends StatelessWidget {
  final String imageUrl;
  final int gameType;

  const GameListItem({Key? key, required this.imageUrl, required this.gameType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = themeMode[GetStorage('session').hasData('pageColor')
            ? GetStorage('session').read('pageColor')
            : 1]
        .toString();

    return Container(
      width: (Get.width - 114) / 2,
      height: (Get.width - 114) / 3,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .10),
            offset: Offset(0.5, 0.5),
            spreadRadius: 1.5,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: imageUrl != '' || imageUrl.isNotEmpty
              ? CacheImage(
                  url: imageUrl,
                  width: double.infinity,
                  height: 105,
                  fit: BoxFit.cover,
                  emptyImageUrl:
                      'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                )
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
  final Function updateGameHistory;
  final List? gameHistoryList;
  final int deductHeight;

  const GameListView(
      {Key? key,
      required this.updateGameHistory,
      this.gameHistoryList,
      required this.deductHeight})
      : super(key: key);
  @override
  _GameListViewState createState() => _GameListViewState();
}

class _GameListViewState extends State<GameListView>
    with SingleTickerProviderStateMixin {
  final GamesListController gamesListController =
      Get.put(GamesListController());
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  var filteredGameCategories = [];

  @override
  void initState() {
    super.initState();
    _filterGameCategories();
    widget.updateGameHistory();
    _tabController = TabController(
      length: filteredGameCategories.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.index = 0;
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose(); // 釋放 _tabController
    super.dispose();
  }

  _handleTabSelection() {
    gamesListController.updateSelectedCategoryIndex(_tabController.index);
    if (_tabController.index == -1) {
      widget.updateGameHistory();
    }
  }

  // 寫一個篩選遊戲類別的方法
  _filterGameCategories() {
    Set<int> gameTypes = <int>{};

    var gameCategoriesMapper = [
      {
        'name': '全部',
        'gameType': 0,
        'icon': 'packages/game/assets/images/game_lobby/menu-all@3x.webp',
      },
      {
        'name': '最近',
        'gameType': -1,
        'icon': 'packages/game/assets/images/game_lobby/menu-new@3x.webp',
      },
      {
        'name': '捕魚',
        'gameType': 1,
        'icon': 'packages/game/assets/images/game_lobby/menu-fish@3x.webp',
      },
      {
        'name': '真人',
        'gameType': 2,
        'icon': 'packages/game/assets/images/game_lobby/menu-live@3x.webp',
      },
      {
        'name': '棋牌',
        'gameType': 3,
        'icon': 'packages/game/assets/images/game_lobby/menu-poker@3x.webp',
      },
      {
        'name': '電子',
        'gameType': 4,
        'icon': 'packages/game/assets/images/game_lobby/menu-slot@3x.webp',
      },
      {
        'name': '體育',
        'gameType': 5,
        'icon': 'packages/game/assets/images/game_lobby/menu-sport@3x.webp',
      },
      {
        'name': '彩票',
        'gameType': 6,
        'icon': 'packages/game/assets/images/game_lobby/menu-lottery@3x.webp',
      }
    ];

    for (var game in gamesListController.games) {
      gameTypes.add(game.gameType);
    }

    // gameCategories中的gameType在gameTypes中的元素，其中gameType=0跟-1的元素不會被篩選掉

    filteredGameCategories = gameCategoriesMapper
        .where((category) =>
            gameTypes.contains(category['gameType']) ||
            category['gameType'] == 0 ||
            category['gameType'] == -1)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => gamesListController.games.isNotEmpty
        ? SizedBox(
            width: Get.width,
            height: Get.height -
                widget.deductHeight -
                (GetPlatform.isWeb ? 250 : 270),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 0,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SizedBox(
                      width: Get.height - 180,
                      height: 60,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        labelPadding: const EdgeInsets.only(right: 0),
                        indicatorColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: filteredGameCategories
                            .map(
                              (category) => RotatedBox(
                                quarterTurns: 3,
                                child: GameScrollViewTabs(
                                  text: category['name'].toString(),
                                  icon: category['icon'].toString(),
                                  isActive: gamesListController
                                          .selectedCategoryIndex.value ==
                                      filteredGameCategories.indexOf(category),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                    thickness: 1, width: 12, color: Colors.transparent),
                Flexible(
                  flex: 1,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: filteredGameCategories
                        .map(
                          (category) => gamesListController.games.isNotEmpty
                              ? _buildGameList(category['gameType'] as int)
                              : const SizedBox(),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator());
  }

  Widget _buildGameList(int gameType) {
    final gameListResult = gameType == 0
        ? gamesListController.games.value
        : widget.gameHistoryList!.isNotEmpty && gameType == -1
            ? widget.gameHistoryList
            : gamesListController.games.value
                .where((game) => game.gameType == gameType)
                .toList()
                .obs;
    final totalItemCount = gameListResult!.length.isOdd
        ? (gamesListController.games.length ~/ 2).toInt() + 1 // 如果是奇數就加1
        : gamesListController.games.length ~/ 2;

    final filterItemCount = gameListResult.length.isOdd
        ? (gameListResult.length ~/ 2).toInt() + 1 // 如果是奇數就加1
        : gameListResult.length ~/ 2;

    final historyItemCount = widget.gameHistoryList!.length.isOdd
        ? (widget.gameHistoryList!.length ~/ 2).toInt() + 1
        : widget.gameHistoryList!.length ~/ 2;

    return gameListResult.isEmpty
        ? Center(
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
                  '暫無紀錄',
                  style: TextStyle(color: gameLobbyLoginFormColor),
                )
              ],
            ),
          )
        : ListView.separated(
            controller: _scrollController,
            itemCount: gameType == 0
                ? gameType == -1
                    ? historyItemCount
                    : totalItemCount
                : filterItemCount,
            separatorBuilder: (context, index) =>
                const VerticalDivider(thickness: 1, width: 12),
            itemBuilder: (BuildContext context, int index) {
              return Wrap(
                spacing: 6,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // handleGameItem(
                      //   context,
                      //   gameId: gameListResult[index * 2].gameId,
                      //   updateGameHistory: widget.updateGameHistory,
                      // );
                    },
                    child: GameListItem(
                      imageUrl: gameListResult[index * 2].imgUrl,
                      gameType: gameListResult[index * 2].gameType,
                    ),
                  ),
                  if (index * 2 + 1 < gameListResult.length)
                    GestureDetector(
                      onTap: () {
                        // handleGameItem(
                        //   context,
                        //   gameId: gameListResult[index * 2 + 1].gameId,
                        //   updateGameHistory: widget.updateGameHistory,
                        // );
                      },
                      child: GameListItem(
                        imageUrl: gameListResult[index * 2 + 1].imgUrl,
                        gameType: gameListResult[index * 2 + 1].gameType,
                      ),
                    ),
                  const SizedBox(width: double.infinity, height: 8)
                ],
              );
            },
          );
  }
}
