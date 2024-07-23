import 'package:flutter/material.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/utils/loading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameListViewBuilder extends StatelessWidget {
  final List filteredGameCategories;
  final Function buildGameList;
  final GamesListController gamesListController =
      Get.find<GamesListController>();

  GameListViewBuilder({
    Key? key,
    required this.filteredGameCategories,
    required this.buildGameList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GamesListController>(
      id: 'gameList',
      builder: (controller) {
        if (filteredGameCategories.isEmpty) {
          return const Center(
            child: Text(
              'No categories available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return IndexedStack(
          children: filteredGameCategories.map<Widget>((category) {
            return gamesListController.games.isNotEmpty
                ? buildGameList(
                    gameType: gamesListController.gameTypeIndex.value,
                    tpCode: gamesListController.gamePlatformTpCode.value,
                  )
                : const GameLoading();
          }).toList(),
        );
      },
    );
  }
}
