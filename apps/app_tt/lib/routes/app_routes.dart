library app_routes;

import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/shorts_type.dart';
import 'package:shared/navigator/delegate.dart';

import '../pages/home.dart' as home_page;
import '../pages/video.dart' as video_page;
import '../pages/publisher.dart' as publisher_page;
import '../pages/tag.dart' as tag_page;
import '../pages/apps.dart' as apps_page;
import '../pages/login.dart' as login_page;
import '../pages/register.dart' as register_page;
import '../pages/video_by_block.dart' as video_by_block_page;
import '../pages/actors.dart' as actors_page;
import '../pages/filter.dart' as filter_page;
import '../pages/search.dart' as search_page;
import '../pages/vip.dart' as vip_page;
import '../pages/coin.dart' as coin_page;
import '../pages/share.dart' as share_page;
import '../pages/shorts_by_common.dart' as shorts_by_common_page;
import '../pages/shorts_by_local.dart' as shorts_by_local_page;

final Map<String, RouteWidgetBuilder> appRoutes = {
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
  AppRoutes.tag: (context, args) => tag_page.TagPage(
        key: ValueKey('tag-video-${args['id']}'),
        id: args['id'] as int,
        title: args['title'] as String,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
  // AppRoutes.actor: (context, args) => actor_page.ActorPage(
  //       id: args['id'] as int,
  //     ),
  AppRoutes.login: (context, args) => const login_page.LoginPage(),
  // AppRoutes.nickname: (context, args) => const nickname_page.NicknamePage(),
  AppRoutes.register: (context, args) => const register_page.RegisterPage(),
  AppRoutes.share: (context, args) => const share_page.SharePage(),
  // AppRoutes.shareRecord: (context, args) =>
  //     const sharerecord_page.ShareRecord(),
  AppRoutes.apps: (context, args) => const apps_page.AppsPage(),
  // AppRoutes.notifications: (context, args) =>
  //     const notifications_page.NotificationsPage(),
  AppRoutes.search: (context, args) => search_page.SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        autoSearch: args['autoSearch'] as bool,
      ),
  AppRoutes.filter: (context, args) => const filter_page.FilterPage(),
  AppRoutes.actors: (context, args) => const actors_page.ActorsPage(),
  AppRoutes.vip: (context, args) => const vip_page.VipPage(),
  AppRoutes.coin: (context, args) => const coin_page.CoinPage(),

  // AppRoutes.supplier: (context, args) => supplier_page.SupplierPage(
  //       id: args['id'] as int,
  //     ),
  // AppRoutes.supplierTag: (context, args) =>
  //     supplier_tag_video_page.SupplierTagVideoPage(
  //       tagId: args['tagId'] as int,
  //       tagName: args['tagName'],
  //     ),
  AppRoutes.shorts: (context, args) => shorts_by_common_page.ShortsByCommonPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        id: args['id'] as int,
        type: args['type'] as ShortsType,
      ),
  AppRoutes.shortsByLocal: (context, args) =>
      shorts_by_local_page.ShortsByLocalPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        itemId: args['itemId'] as int,
      ),
  // AppRoutes.configs: (context, args) => const configs_page.ConfigsPage(),
  // AppRoutes.updatePassword: (context, args) =>
  //     const update_password_page.UpdatePasswordPage(),
  // AppRoutes.idCard: (context, args) => const id_page.IDCardPage(),
  // AppRoutes.suppliers: (context, args) =>
  //     const suppliers_screen.SuppliersPage(),
};
