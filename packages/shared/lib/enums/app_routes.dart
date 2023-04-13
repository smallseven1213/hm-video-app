enum AppRoutes {
  splash,
  ad,
  home,
  video,
  videoByBlock,
  vendorVideos,
  tag,
  gameDeposit,
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
      case AppRoutes.vendorVideos:
        return '/vendor_videos';
      case AppRoutes.tag:
        return '/tag';
      case AppRoutes.gameDeposit:
        return '/game/deposit';
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
      default:
        return '/unknown';
    }
  }
}
