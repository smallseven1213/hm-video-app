import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared/apis/game_api.dart';
import 'package:shared/controllers/game_banner_controller.dart';
import 'package:shared/controllers/game_list_controller.dart';
import 'package:shared/controllers/game_wallet_controller.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/screens/game/game_theme_config.dart';
import 'package:shared/models/game_list.dart';
import 'package:shared/screens/game/lobby/game_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameLobby extends StatefulWidget {
  final String? bottom;
  const GameLobby({Key? key, this.bottom}) : super(key: key);

  @override
  State<GameLobby> createState() => _GameLobbyState();
}

class CustomFabPosition extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(scaffoldGeometry.scaffoldSize.width * .8, 430);
  }
}

var switchPaymentPageType = {
  'normal': 1,
  'refactor': 2,
};

class _GameLobbyState extends State<GameLobby> {
  bool isShowGameList = false;
  bool updatedUserInfo = false;
  List<GameItem> gameList = [];
  List gameHistoryList = [];
  bool isShowFab = false;

  final gamesListController = GamesListController();
  final gameBannerController = GameBannerController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.wait([
      GameLobbyApi().registerGame(),
    ]).then((value) {
      GameWalletController().fetchWallets();
      GameBannerController();
      getGameHistory();
    });
  }

  _refreshData() {
    getGameHistory();
  }

  // 先取得當前的localStorage的遊戲歷史紀錄
  Future<void> getGameHistory() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final userController = UserController();
    final gameWalletController = GameWalletController();

    return Obx(() => Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: gameLobbyBgColor,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: gameLobbyBgColor,
            ),
            centerTitle: true,
            title: Text(
              '游戏大厅',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: gameLobbyAppBarTextColor),
            ),
            // 如果roles是'guest'，就顯示登入按鈕
            actions: userController.info.value.roles.contains('guest')
                ? [
                    InkWell(
                      onTap: () {
                        // showGameLoginDialog(
                        //   context,
                        //   content: GameLobbyLoginTabs(
                        //     type: Type.login,
                        //     onSuccess: () {
                        //       _refreshData();
                        //       userState.mutateAll();
                        //       gameWalletController.mutate();
                        //       Navigator.pop(context);
                        //     },
                        //   ),
                        //   onClosed: () => Navigator.pop(context),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: gamePrimaryButtonColor,
                          ),
                          child: Center(
                            child: Text(
                              '註冊/登入',
                              style: TextStyle(
                                color: gamePrimaryButtonTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                color: gameLobbyBgColor,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Banners(data: gameBannerController.gameBanner),
                        // Marquee(data: gameBannerController.gameMarquee),
                        // UserInfo(
                        //   type: 'lobby',
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: const [
                        //       // 存款
                        //       UserInfoDeposit(onTap: () async {
                        //         // var res = await gto('/game/deposit');
                        //         var res = await gto(
                        //             gamesState.switchPaymentPage.value ==
                        //                     switchPaymentPageType['normal']
                        //                 ? '/game/deposit'
                        //                 : '/game/deposit2');
                        //         _refreshData();
                        //       }),
                        //       // 提現
                        //       UserInfoWithdraw(onTap: () async {
                        //         var res = await gto('/game/withdraw');
                        //         // widget.onNextPagePop();
                        //         _refreshData();
                        //       }),
                        //       // 客服
                        //       const UserInfoService(),
                        //     ],
                        //   ),
                        // ),
                        GameListView(
                          updateGameHistory: () {
                            getGameHistory();
                          },
                          gameHistoryList: gameHistoryList,
                          deductHeight:
                              (gameBannerController.gameBanner.isNotEmpty &&
                                              gameBannerController
                                                      .gameBanner.length >
                                                  1
                                          ? 165
                                          : gameBannerController
                                                      .gameBanner.isNotEmpty &&
                                                  gameBannerController
                                                          .gameBanner.length <=
                                                      1
                                              ? 105
                                              : 0)
                                      .toInt() +
                                  (gameBannerController.gameMarquee.isNotEmpty
                                          ? 20
                                          : 0)
                                      .toInt(),
                        )
                      ],
                    ),
                  ),
                )),
          ),
          floatingActionButton: gamesListController.isShowFab == true &&
                  userController.info.value.roles.contains('guest')
              ? Container(
                  width: 65,
                  height: 65,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image:
                          AssetImage('assets/img/game_lobby/red-envelope.webp'),
                    ),
                  ),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isShowFab = false;
                          });
                        },
                        child: const SizedBox(
                          width: 65,
                          height: 15,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // gto('/member/upgrade');
                        },
                        child: const SizedBox(
                          width: 65,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          floatingActionButtonLocation: CustomFabPosition(),
        ));
  }
}
