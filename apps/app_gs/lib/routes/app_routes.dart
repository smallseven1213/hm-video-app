library app_routes;

import 'package:flutter/material.dart';
import 'package:app_gs/pages/actor.dart';
import 'package:app_gs/pages/configs.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../pages/actors.dart';
import '../pages/collection.dart';
import '../pages/home.dart';
import '../pages/id.dart';
import '../pages/login.dart';
import '../pages/playrecord.dart';
import '../pages/register.dart';
import '../pages/nickname.dart';
import '../pages/share.dart';
import '../pages/sharerecord.dart';
import '../pages/shorts_by_block.dart';
import '../pages/shorts_by_local.dart';
import '../pages/shorts_by_supplier.dart';
import '../pages/shorts_by_tag.dart';
import '../pages/supplier.dart';
import '../pages/supplier_tag_video.dart';
import '../pages/tag_video.dart';
import '../pages/publisher.dart';
import '../pages/update_password.dart';
import '../pages/video_by_block.dart';
import '../pages/favorites.dart';
import '../pages/filter.dart';
import '../pages/notifications.dart';
import '../pages/search.dart';
import '../pages/video.dart';
import '../screens/apps_screen/index.dart';

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.home.value: (context, args) => HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
  AppRoutes.video.value: (context, args) => Video(args: args),
  AppRoutes.videoByBlock.value: (context, args) => VideoByBlockPage(
        blockId: args['blockId'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
  AppRoutes.publisher.value: (context, args) => PublisherPage(
        id: args['id'] as int,
        // title: args['title'] as String,
      ),
  AppRoutes.tag.value: (context, args) => TagVideoPage(
        key: ValueKey('tag-video-${args['id']}'),
        id: args['id'] as int,
        title: args['title'] as String,
      ),
  AppRoutes.actor.value: (context, args) => ActorPage(
        id: args['id'] as int,
      ),
  AppRoutes.login.value: (context, args) => const LoginPage(),
  AppRoutes.nickname.value: (context, args) => const NicknamePage(),
  AppRoutes.register.value: (context, args) => const RegisterPage(),
  AppRoutes.share.value: (context, args) => const SharePage(),
  AppRoutes.playRecord.value: (context, args) => const PlayRecordPage(),
  AppRoutes.shareRecord.value: (context, args) => const ShareRecord(),
  AppRoutes.apps.value: (context, args) => const AppsScreen(),
  AppRoutes.favorites.value: (context, args) => const FavoritesPage(),
  AppRoutes.collection.value: (context, args) => const CollectionPage(),
  AppRoutes.notifications.value: (context, args) => const NotificationsPage(),
  AppRoutes.search.value: (context, args) => SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        dontSearch: args['dontSearch'] as bool,
      ),
  AppRoutes.filter.value: (context, args) => const FilterPage(),
  AppRoutes.actors.value: (context, args) => const ActorsPage(),
  AppRoutes.supplier.value: (context, args) => SupplierPage(
        id: args['id'] as int,
      ),
  AppRoutes.supplierTag.value: (context, args) => SupplierTagVideoPage(
      tagId: args['tagId'] as int, tagName: args['tagName']),
  AppRoutes.shortsByTag.value: (context, args) => ShortsByTagPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        tagId: args['tagId'] as int,
      ),
  AppRoutes.shortsBySupplier.value: (context, args) => ShortsBySupplierPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        supplierId: args['supplierId'] as int,
      ),
  AppRoutes.shortsByBlock.value: (context, args) => ShortsByBlockPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        areaId: args['areaId'] as int,
      ),
  AppRoutes.shortsByLocal.value: (context, args) => ShortsByLocalPage(
        uuid: args['uuid'] as String,
        videoId: args['videoId'] as int,
        itemId: args['itemId'] as int,
      ),
  AppRoutes.configs.value: (context, args) => const ConfigsPage(),
  AppRoutes.updatePassword.value: (context, args) => const UpdatePasswordPage(),
  AppRoutes.idCard.value: (context, args) => const IDCardPage(),
};
