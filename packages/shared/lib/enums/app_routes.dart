enum AppRoutes {
  splash,
  ad,
  home,
  video,
  videoByBlock,
  publisher,
  tag,
  gameLobby,
  gameDepositList,
  gameDepositPolling,
  gameWithdraw,
  gameWebview,
  login,
  register,
  share,
  playRecord,
  shareRecord,
  apps,
  favorites,
  collection,
  notifications,
  search,
  filter,
  actor,
  actors,
  short,
  nickname,
  supplier,
  supplierTag
}

extension AppRoutesExtension on AppRoutes {
  String get value {
    switch (this) {
      case AppRoutes.splash:
        return '/';
      case AppRoutes.ad:
        return '/ad';
      case AppRoutes.home:
        return '/home';
      case AppRoutes.video:
        return '/video';
      case AppRoutes.videoByBlock:
        return '/video_by_block';
      case AppRoutes.publisher:
        return '/publisher';
      case AppRoutes.tag:
        return '/tag';
      case AppRoutes.gameLobby:
        return '/game';
      case AppRoutes.gameWithdraw:
        return '/withdraw';
      case AppRoutes.gameDepositList:
        return '/game/deposit_page_list';
      case AppRoutes.gameDepositPolling:
        return '/game/deposit_page_polling';
      case AppRoutes.gameWebview:
        return '/game/webview';
      case AppRoutes.login:
        return '/login';
      case AppRoutes.register:
        return '/register';
      case AppRoutes.share:
        return '/share';
      case AppRoutes.playRecord:
        return '/playrecord';
      case AppRoutes.shareRecord:
        return '/sharerecord';
      case AppRoutes.apps:
        return '/apps';
      case AppRoutes.favorites:
        return '/favorites';
      case AppRoutes.collection:
        return '/collection';
      case AppRoutes.notifications:
        return '/notifications';
      case AppRoutes.search:
        return '/search';
      case AppRoutes.filter:
        return '/filter';
      case AppRoutes.actors:
        return '/actors';
      case AppRoutes.actor:
        return '/actor';
      case AppRoutes.short:
        return '/short';
      case AppRoutes.nickname:
        return '/user/nickname';
      case AppRoutes.supplier:
        return '/supplier';
      case AppRoutes.supplierTag:
        return '/supplier_tag';
      default:
        return '/unknown';
    }
  }
}
