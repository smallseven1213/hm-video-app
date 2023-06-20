import 'package:flutter/material.dart';
import 'package:game/utils/show_confirm_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:game/utils/on_loading.dart';
import 'package:game/apis/game_api.dart';

import '../enums/game_app_routes.dart';

String gameUrl = '';

getGameUrl(String tpCode, int gameId, int gameType) async {
  var res = await GameLobbyApi().enterGame(tpCode, gameId, gameType);

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

void handleGameItem(BuildContext context,
    {gameId, updateGameHistory, tpCode, direction, gameType}) async {
  try {
    onLoading(context, status: true);
    await getGameUrl(tpCode, gameId, gameType);
    await _saveGameHistory(gameId: gameId);
    updateGameHistory();

    await Future.delayed(const Duration(seconds: 1));

    if (gameUrl == '') {
      logger.i('gameUrl is empty');
      // ignore: use_build_context_synchronously
      onLoading(context, status: false);
      // ignore: use_build_context_synchronously
      showConfirmDialog(
        context: context,
        title: '遊戲維護中',
        content: '遊戲維護中，請稍後再試',
        confirmText: '確認',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
      return;
    } else {
      // ignore: use_build_context_synchronously
      onLoading(context, status: false);
      // ignore: use_build_context_synchronously
      MyRouteDelegate.of(context).push(
        GameAppRoutes.webview.value,
        args: {
          'url': gameUrl,
          'direction': direction,
        },
      );
    }
  } catch (error) {
    logger.i('getGameUrl error: $error');
    onLoading(context, status: false);
    showConfirmDialog(
      context: context,
      title: '遊戲維護中',
      content: '遊戲維護中，請稍後再試',
      confirmText: '確認',
      onConfirm: () {
        Navigator.pop(context);
      },
    );
  }
}
