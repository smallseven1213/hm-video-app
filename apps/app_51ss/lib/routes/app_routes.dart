library app_routes;

import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../pages/home.dart' as home_page;
import '../pages/share.dart' as share_page;
import '../pages/collection.dart' as collection_page;
import '../pages/login.dart' as login_page;
import '../pages/register.dart' as register_page;
import '../pages/filter.dart' as filter_page;
import '../pages/search.dart' as search_page;
import '../pages/actors.dart' as actors_page;
import '../pages/actor.dart' as actor_page;
import '../pages/tag.dart' as tag_page;
import '../pages/video_by_block.dart' as video_by_block_page;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.home: (context, args) => home_page.HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
  AppRoutes.share: (context, args) => const share_page.SharePage(),
  AppRoutes.collection: (context, args) =>
      const collection_page.CollectionPage(),
  AppRoutes.login: (context, args) => const login_page.LoginPage(),
  AppRoutes.register: (context, args) => const register_page.RegisterPage(),
  AppRoutes.filter: (context, args) => const filter_page.FilterPage(),
  AppRoutes.search: (context, args) => search_page.SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        autoSearch: args['autoSearch'] as bool,
      ),
  AppRoutes.actors: (context, args) => const actors_page.ActorsPage(),
  AppRoutes.actor: (context, args) => actor_page.ActorPage(
        id: args['id'] as int,
      ),
  AppRoutes.tag: (context, args) => tag_page.TagPage(
        key: ValueKey('tag-video-${args['id']}'),
        id: args['id'] as int,
        title: args['title'] as String,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
  AppRoutes.videoByBlock: (context, args) =>
      video_by_block_page.VideoByBlockPage(
        blockId: args['blockId'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
        film: args['film'] == null ? 1 : args['film'] as int,
      ),
};
