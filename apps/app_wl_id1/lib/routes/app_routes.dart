library app_routes;

import 'package:flutter/material.dart';
import 'package:app_wl_id1/pages/actor.dart' as actor_page;
import 'package:app_wl_id1/pages/configs.dart' as configs_page;
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/shorts_type.dart';
import 'package:shared/navigator/delegate.dart';

import '../pages/actors.dart' as actors_page;
import '../pages/collection.dart' as collection_page;
import '../pages/home.dart' as home_page;
import '../pages/id.dart' as id_page;
import '../pages/login.dart' as login_page;
import '../pages/playrecord.dart' as playrecord_page;
import '../pages/register.dart' as register_page;
import '../pages/nickname.dart' as nickname_page;
import '../pages/share.dart' as share_page;
import '../pages/sharerecord.dart' as sharerecord_page;
import '../pages/shorts_by_local.dart' as shorts_by_local_page;
import '../pages/shorts_by_common.dart' as shorts_by_common_page;
import '../pages/supplier.dart' as supplier_page;
import '../pages/supplier_tag_video.dart' as supplier_tag_video_page;
import '../pages/tag_video.dart' as tag_video_page;
import '../pages/publisher.dart' as publisher_page;
import '../pages/update_password.dart' as update_password_page;
import '../pages/video_by_block.dart' as video_by_block_page;
import '../pages/favorites.dart' as favorites_page;
import '../pages/filter.dart' as filter_page;
import '../pages/notifications.dart' as notifications_page;
import '../pages/search.dart' as search_page;
import '../pages/video.dart' as video_page;
import '../pages/apps.dart' as apps_page;
import '../screens/demo.dart' as demo_screen;
import '../pages/suppliers.dart' as suppliers_screen;
import '../pages/games.dart' as games_page;
import '../pages/tag_games.dart' as tag_games_page;
import '../pages/vip.dart' as vip_page;
import '../pages/coin.dart' as coin_page;
import '../pages/post.dart' as post_page;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.demo: (context, args) => const demo_screen.Demo(),
  AppRoutes.home: (context, args) => home_page.HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
  AppRoutes.video: (context, args) => video_page.Video(args: args),
  AppRoutes.videoByBlock: (context, args) =>
      video_by_block_page.VideoByBlockPage(
        blockId: args['blockId'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
  AppRoutes.publisher: (context, args) => publisher_page.PublisherPage(
        id: args['id'] as int,
      ),
  AppRoutes.tag: (context, args) => tag_video_page.TagVideoPage(
        key: ValueKey('tag-video-${args['id']}'),
        id: args['id'] as int,
        title: args['title'] as String,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
  AppRoutes.tagGames: (context, args) => tag_games_page.TagGamesPage(
        tag: args['tag'] as String,
      ),
  AppRoutes.actor: (context, args) => actor_page.ActorPage(
        id: args['id'] as int,
      ),
  AppRoutes.login: (context, args) => const login_page.LoginPage(),
  AppRoutes.nickname: (context, args) => const nickname_page.NicknamePage(),
  AppRoutes.register: (context, args) => const register_page.RegisterPage(),
  AppRoutes.share: (context, args) => const share_page.SharePage(),
  AppRoutes.playRecord: (context, args) =>
      const playrecord_page.PlayRecordPage(),
  AppRoutes.shareRecord: (context, args) =>
      const sharerecord_page.ShareRecord(),
  AppRoutes.apps: (context, args) => const apps_page.AppsPage(),
  AppRoutes.favorites: (context, args) => const favorites_page.FavoritesPage(),
  AppRoutes.collection: (context, args) =>
      const collection_page.CollectionPage(),
  AppRoutes.notifications: (context, args) =>
      const notifications_page.NotificationsPage(),
  AppRoutes.search: (context, args) => search_page.SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        autoSearch: args['autoSearch'] as bool,
      ),
  AppRoutes.filter: (context, args) => const filter_page.FilterPage(),
  AppRoutes.actors: (context, args) => const actors_page.ActorsPage(),
  AppRoutes.supplier: (context, args) => supplier_page.SupplierPage(
        id: args['id'] as int,
      ),
  AppRoutes.supplierTag: (context, args) =>
      supplier_tag_video_page.SupplierTagVideoPage(
        tagId: args['tagId'] as int,
        tagName: args['tagName'],
      ),
  AppRoutes.shorts: (context, args) => shorts_by_common_page.ShortsByCommonPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        id: args['id'] as int,
        type: args['type'] as ShortsType,
      ),
  AppRoutes.games: (context, args) => games_page.GamesPage(
        gameAreaId: args['gameAreaId'] as int,
        gameAreaName: args['gameAreaName'] as String,
      ),
  AppRoutes.shortsByLocal: (context, args) =>
      shorts_by_local_page.ShortsByLocalPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        itemId: args['itemId'] as int,
      ),
  AppRoutes.configs: (context, args) => const configs_page.ConfigsPage(),
  AppRoutes.updatePassword: (context, args) =>
      const update_password_page.UpdatePasswordPage(),
  AppRoutes.idCard: (context, args) => const id_page.IDCardPage(),
  AppRoutes.suppliers: (context, args) =>
      const suppliers_screen.SuppliersPage(),
  AppRoutes.vip: (context, args) => const vip_page.VipPage(),
  AppRoutes.coin: (context, args) => const coin_page.CoinPage(),
  AppRoutes.post: (context, args) => post_page.PostPage(
        id: args['id'] as int,),
};
