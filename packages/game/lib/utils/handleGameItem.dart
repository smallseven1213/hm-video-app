import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:game/utils/onLoading.dart';
import 'package:game/apis/game_api.dart';

String gameUrl = '';

getGameUrl(String tpCode, int gameId) async {
  var res = await GameLobbyApi().enterGame(tpCode, gameId);

  if (res == null) {
    gameUrl = '';
    return;
  }

  if (res['loginUrls'].length > 0) {
    gameUrl = res['loginUrls'][0];
  }
}

_saveGameHistory({gameId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> gameHistory = prefs.getStringList('gameHistory') ?? []; // 取得歷史紀錄
  if (gameHistory.length >= 5) {
    gameHistory.removeLast();
  }
  // 檢查有無重複
  if (gameHistory.contains(gameId.toString())) {
    gameHistory.remove(gameId.toString());
  }
  // 加入到gameHistory的最後一筆
  gameHistory.insert(0, gameId.toString());
  prefs.setStringList('gameHistory', gameHistory);
}

void handleGameItem(BuildContext context, {gameId, updateGameHistory}) async {
  try {
    onLoading(context, status: true);
    await getGameUrl('wali', gameId);
    await _saveGameHistory(gameId: gameId);
    updateGameHistory();

    await Future.delayed(const Duration(seconds: 1));

    if (gameUrl == '') {
      print('gameUrl is empty');
      onLoading(context, status: false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Text('遊戲維護中'),
            ),
          );
        },
      );
      return;
    } else {
      onLoading(context, status: false);
      MyRouteDelegate.of(context).push(
        AppRoutes.gameWebview.value,
        args: {
          'url': gameUrl,
        },
      );
    }
  } catch (error) {
    print('getGameUrl error: $error');
    onLoading(context, status: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Text('遊戲維護中'),
          ),
        );
      },
    );
  }
}
