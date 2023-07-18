library app_routes;

import 'package:flutter/material.dart';
import 'package:app_gs/pages/actor.dart' as actor_page;
import 'package:app_gs/pages/configs.dart' as configs_page;
import 'package:shared/enums/app_routes.dart';
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
import '../pages/shorts_by_block.dart' as shorts_by_block_page;
import '../pages/shorts_by_local.dart' as shorts_by_local_page;
import '../pages/shorts_by_channel.dart' as shorts_by_channel_page;
import '../pages/shorts_by_supplier.dart' as shorts_by_supplier_page;
import '../pages/shorts_by_tag.dart' as shorts_by_tag_page;
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
import '../screens/apps_screen/index.dart' as apps_screen;
import '../screens/demo.dart' as demo_screen;
import '../pages/suppliers.dart' as suppliers_screen;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.demo.value: (context, args) => demo_screen.Demo(),
  AppRoutes.home.value: (context, args) => home_page.HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
  AppRoutes.video.value: (context, args) => video_page.Video(args: args),
  AppRoutes.videoByBlock.value: (context, args) =>
      video_by_block_page.VideoByBlockPage(
        blockId: args['blockId'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
  AppRoutes.publisher.value: (context, args) => publisher_page.PublisherPage(
        id: args['id'] as int,
      ),
  AppRoutes.tag.value: (context, args) => tag_video_page.TagVideoPage(
        key: ValueKey('tag-video-${args['id']}'),
        id: args['id'] as int,
        title: args['title'] as String,
      ),
  AppRoutes.actor.value: (context, args) => actor_page.ActorPage(
        id: args['id'] as int,
      ),
  AppRoutes.login.value: (context, args) => const login_page.LoginPage(),
  AppRoutes.nickname.value: (context, args) =>
      const nickname_page.NicknamePage(),
  AppRoutes.register.value: (context, args) =>
      const register_page.RegisterPage(),
  AppRoutes.share.value: (context, args) => const share_page.SharePage(),
  AppRoutes.playRecord.value: (context, args) =>
      const playrecord_page.PlayRecordPage(),
  AppRoutes.shareRecord.value: (context, args) =>
      const sharerecord_page.ShareRecord(),
  AppRoutes.apps.value: (context, args) => const apps_screen.AppsScreen(),
  AppRoutes.favorites.value: (context, args) =>
      const favorites_page.FavoritesPage(),
  AppRoutes.collection.value: (context, args) =>
      const collection_page.CollectionPage(),
  AppRoutes.notifications.value: (context, args) =>
      const notifications_page.NotificationsPage(),
  AppRoutes.search.value: (context, args) => search_page.SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        autoSearch: args['autoSearch'] as bool,
      ),
  AppRoutes.filter.value: (context, args) => const filter_page.FilterPage(),
  AppRoutes.actors.value: (context, args) => const actors_page.ActorsPage(),
  AppRoutes.supplier.value: (context, args) => supplier_page.SupplierPage(
        id: args['id'] as int,
      ),
  AppRoutes.supplierTag.value: (context, args) =>
      supplier_tag_video_page.SupplierTagVideoPage(
        tagId: args['tagId'] as int,
        tagName: args['tagName'],
      ),
  AppRoutes.shortsByTag.value: (context, args) =>
      shorts_by_tag_page.ShortsByTagPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        tagId: args['tagId'] as int,
      ),
  AppRoutes.shortsBySupplier.value: (context, args) =>
      shorts_by_supplier_page.ShortsBySupplierPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        supplierId: args['supplierId'] as int,
      ),
  AppRoutes.shortsByBlock.value: (context, args) =>
      shorts_by_block_page.ShortsByBlockPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        areaId: args['areaId'] as int,
      ),
  AppRoutes.shortsByLocal.value: (context, args) =>
      shorts_by_local_page.ShortsByLocalPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        itemId: args['itemId'] as int,
      ),
  AppRoutes.shortsByChannel.value: (context, args) =>
      shorts_by_channel_page.ShortsByChannelPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        supplierId: args['supplierId'] as int,
      ),
  AppRoutes.configs.value: (context, args) => const configs_page.ConfigsPage(),
  AppRoutes.updatePassword.value: (context, args) =>
      const update_password_page.UpdatePasswordPage(),
  AppRoutes.idCard.value: (context, args) => const id_page.IDCardPage(),
  AppRoutes.suppliers.value: (context, args) =>
      const suppliers_screen.SuppliersPage(),
};
