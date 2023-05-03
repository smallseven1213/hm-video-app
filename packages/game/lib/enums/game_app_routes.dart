enum GameAppRoutes {
  home,
  gameLobby,
  gameDepositPageList,
  gameDepositPagePolling,
  gameWithdraw,
}

extension AppRoutesExtension on GameAppRoutes {
  String get value {
    switch (this) {
      case GameAppRoutes.home:
        return '/home';
      case GameAppRoutes.gameLobby:
        return '/game';
      case GameAppRoutes.gameWithdraw:
        return '/withdraw';
      case GameAppRoutes.gameDepositPageList:
        return '/game/deposit_page_list';
      case GameAppRoutes.gameDepositPagePolling:
        return '/game/deposit_page_polling';
      default:
        return '/unknown';
    }
  }
}
