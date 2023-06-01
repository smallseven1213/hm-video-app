enum GameAppRoutes {
  home,
  lobby,
  depositList,
  depositPolling,
  depositDetail,
  withdraw,
  webview,
  paymentResult,
  setFundPassword,
  setBankcard,
  depositRecord,
  withdrawRecord,
}

extension AppRoutesExtension on GameAppRoutes {
  String get value {
    switch (this) {
      case GameAppRoutes.lobby:
        return '/game';
      case GameAppRoutes.withdraw:
        return '/game/withdraw';
      case GameAppRoutes.setFundPassword:
        return '/game/set_fund_password';
      case GameAppRoutes.setBankcard:
        return '/game/set_bankcard';
      case GameAppRoutes.depositList:
        return '/game/deposit_page_list';
      case GameAppRoutes.depositPolling:
        return '/game/deposit_page_polling';
      case GameAppRoutes.depositDetail:
        return '/game/deposit/detail';
      case GameAppRoutes.paymentResult:
        return '/game/deposit/payment-result';
      case GameAppRoutes.webview:
        return '/game/webview';
      case GameAppRoutes.depositRecord:
        return '/game/deposit/record';
      case GameAppRoutes.withdrawRecord:
        return '/game/withdraw/record';
      default:
        return '/unknown';
    }
  }
}
