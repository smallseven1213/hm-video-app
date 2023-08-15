library app_routes;

import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/page_loader.dart';

import '../pages/home.dart' deferred as home_page;
import '../pages/share.dart' deferred as share_page;
import '../pages/collection.dart' deferred as collection_page;
// import '../pages/actors.dart' deferred as actors_page;
// import '../pages/id.dart' deferred as id_page;
// import '../pages/login.dart' deferred as login_page;
// import '../pages/playrecord.dart' deferred as playrecord_page;
// import '../pages/register.dart' deferred as register_page;
// import '../pages/nickname.dart' deferred as nickname_page;
// import '../pages/sharerecord.dart' deferred as sharerecord_page;
// import '../pages/shorts_by_block.dart' deferred as shorts_by_block_page;
// import '../pages/shorts_by_local.dart' deferred as shorts_by_local_page;
// import '../pages/shorts_by_channel.dart' deferred as shorts_by_channel_page;
// import '../pages/shorts_by_supplier.dart' deferred as shorts_by_supplier_page;
// import '../pages/shorts_by_tag.dart' deferred as shorts_by_tag_page;
// import '../pages/supplier.dart' deferred as supplier_page;
// import '../pages/supplier_tag_video.dart' deferred as supplier_tag_video_page;
// import '../pages/tag_video.dart' deferred as tag_video_page;
// import '../pages/publisher.dart' deferred as publisher_page;
// import '../pages/update_password.dart' deferred as update_password_page;
// import '../pages/video_by_block.dart' deferred as video_by_block_page;
// import '../pages/favorites.dart' deferred as favorites_page;
// import '../pages/filter.dart' deferred as filter_page;
// import '../pages/notifications.dart' deferred as notifications_page;
// import '../pages/search.dart' deferred as search_page;
// import '../pages/video.dart' deferred as video_page;
// import '../screens/apps_screen/index.dart' deferred as apps_screen;
// import '../screens/demo.dart' deferred as demo_screen;
// import '../pages/suppliers.dart' deferred as suppliers_screen;
import '../widgets/page_loader.dart';
// import '../screens/video_demo.dart' deferred as video_demo_screen;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.home: (context, args) => PageLoader(
        loadLibrary: home_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => home_page.HomePage(
          defaultScreenKey: args['defaultScreenKey'] as String?,
        ),
      ),
  AppRoutes.share: (context, args) => PageLoader(
        loadLibrary: share_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => share_page.SharePage(),
      ),
  AppRoutes.collection: (context, args) => PageLoader(
        loadLibrary: collection_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => collection_page.CollectionPage(),
      ),
};
