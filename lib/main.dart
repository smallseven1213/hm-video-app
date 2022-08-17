import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/configs/c_menu_bar_early.dart';
import 'package:wgp_video_h5app/constants.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/pages/actor_page.dart';
import 'package:wgp_video_h5app/pages/actors_page.dart';
import 'package:wgp_video_h5app/pages/ad_home.dart';
import 'package:wgp_video_h5app/pages/block_more_page.dart';
import 'package:wgp_video_h5app/pages/channel_setting_page.dart';
import 'package:wgp_video_h5app/pages/default.dart';
import 'package:wgp_video_h5app/pages/home.dart';
import 'package:wgp_video_h5app/pages/layout_page.dart';
import 'package:wgp_video_h5app/pages/member_ads_page.dart';
import 'package:wgp_video_h5app/pages/member_page.dart';
import 'package:wgp_video_h5app/pages/member_settings_nickname_page.dart';
import 'package:wgp_video_h5app/pages/member_settings_page.dart';
import 'package:wgp_video_h5app/pages/member_settings_password_page.dart';
import 'package:wgp_video_h5app/pages/member_ticket.dart';
import 'package:wgp_video_h5app/pages/member_upgrade_page.dart';
import 'package:wgp_video_h5app/pages/member_vip_page.dart';
import 'package:wgp_video_h5app/pages/member_wallet_page.dart';
import 'package:wgp_video_h5app/pages/message_center_page.dart';
import 'package:wgp_video_h5app/pages/not_found.dart';
import 'package:wgp_video_h5app/pages/payment_result_page.dart';
import 'package:wgp_video_h5app/pages/publisher_page.dart';
import 'package:wgp_video_h5app/pages/publishers_page.dart';
import 'package:wgp_video_h5app/pages/record_favorite_page.dart';
import 'package:wgp_video_h5app/pages/record_history_page.dart';
import 'package:wgp_video_h5app/pages/record_purchase_page.dart';
import 'package:wgp_video_h5app/pages/search_page.dart';
import 'package:wgp_video_h5app/pages/share_history_page.dart';
import 'package:wgp_video_h5app/pages/share_page.dart';
import 'package:wgp_video_h5app/pages/share_tutorial_page.dart';
import 'package:wgp_video_h5app/pages/splash_screen.dart';
import 'package:wgp_video_h5app/pages/story_page.dart';
import 'package:wgp_video_h5app/pages/story_tag_page.dart';
import 'package:wgp_video_h5app/pages/story_up_page.dart';
import 'package:wgp_video_h5app/pages/vod_filter_page.dart';
import 'package:wgp_video_h5app/pages/vod_player_page.dart';
import 'package:wgp_video_h5app/pages/web_home.dart';
import 'package:wgp_video_h5app/providers/ads_provider.dart';
import 'package:wgp_video_h5app/providers/envent_provider.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/providers/position_provider.dart';
import 'package:wgp_video_h5app/providers/redemption_provider.dart';
import 'package:wgp_video_h5app/providers/supplier_provider.dart';

/*
* https://github.com/jonataslaw/getx/blob/master/documentation/en_US/route_management.md
* https://github.com/jonataslaw/getx/blob/master/documentation/en_US/dependency_management.md
*
* */
class MyObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(previousRoute?.settings.name);
    // window.history
    //     .replaceState({}, document.title, '#/${previousRoute?.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(route.settings.name);
    // print(previousRoute?.settings.name);
    // if ((previousRoute?.settings.name == null && route.settings.name == '/') ||
    //     route.settings.name == null) {
    // }
    if (kIsWeb) {
      window.history.replaceState({}, '', '#/${route.settings.name ?? ''}');
    }
    super.didPush(route, previousRoute);
  }
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  // 延遲關閉閃屏
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 設定基礎綁定
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
  final box = gss();

  // Initialize ============================
  await GetStorage.init('app');
  await GetStorage.init('session');

  var _app = AppController();
  var endpoint = VEndpoint.from();
  await endpoint.fetchDl();
  _app.setEndpoint(endpoint);
  Get.put<AppController>(_app);
  Get.put<AuthProvider>(AuthProvider());
  Get.put<ImagesProvider>(ImagesProvider());
  Get.put<VAdController>(VAdController());
  Get.put<HomeController>(HomeController());

  runApp(GetMaterialApp(
    enableLog: true,
    debugShowCheckedModeBanner: false,
    title: title,
    navigatorObservers: [
      routeObserver,
      MyObserver(),
    ],
    theme: ThemeData(
      // primarySwatch: const MaterialColor(0, {0: mainBgColor}),
      primarySwatch: Colors.amber,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    smartManagement: SmartManagement.onlyBuilder,
    // initialBinding: BindingsBuilder(() async {
    // }),
    // initialRoute: '/home',
    routingCallback: (routing) {
      // print('route: ${routing?.current}');
      if (!kIsWeb) {
        if (routing?.current.contains('\/vod\/') == true ||
            routing?.current.contains('\/_vod\/') == true) {
          SystemChrome.setPreferredOrientations([
            //你要的方向
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            //你要的方向
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      }
      CMenuBarEarly().getItems().forEach((key, value) {
        if (value.uri == routing?.current) {
          Get.find<AppController>().updateNavigationIndex(value.uri, key);
        }
      });
    },
    unknownRoute: GetPage(
      name: '/404',
      page: () => const NotFound(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 168),
      binding: BindingsBuilder(() {
        Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
      }),
    ),
    getPages: [
      GetPage(
        name: kIsWeb ? '/' : '/web_home',
        page: () => const WebHome(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<AdProvider>(() => AdProvider());
          Get.lazyPut<ApkProvider>(() => ApkProvider());
          Get.lazyPut<PositionProvider>(() => PositionProvider());
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<JingangProvider>(() => JingangProvider());
          Get.lazyPut<NoticeProvider>(() => NoticeProvider());
          Get.lazyPut<BlockProvider>(() => BlockProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<VChannelController>(() => VChannelController());
          Get.lazyPut<VNoticeController>(() => VNoticeController());
          Get.lazyPut<VJingangController>(() => VJingangController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());

          Get.lazyPut<BundlingProductProvider>(() => BundlingProductProvider());
          Get.lazyPut<ProductProvider>(() => ProductProvider());
          Get.lazyPut<PaymentProvider>(() => PaymentProvider());
          Get.lazyPut<PrivilegeProvider>(() => PrivilegeProvider());
          Get.lazyPut<OrderProvider>(() => OrderProvider());

          Get.lazyPut<AdsProvider>(() => AdsProvider());

          Get.lazyPut<PhotoProvider>(() => PhotoProvider());
          Get.lazyPut<EventProvider>(() => EventProvider());
        }),
      ),
      GetPage(
        name: kIsWeb ? '/splash' : '/',
        // name: '/',
        page: () => const SplashScreen(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<ApkProvider>(() => ApkProvider());
          Get.lazyPut<AdProvider>(() => AdProvider());
          Get.lazyPut<PositionProvider>(() => PositionProvider());
        }),
      ),
      GetPage(
        name: '/ad_home',
        page: () => const AdHome(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<JingangProvider>(() => JingangProvider());
          Get.lazyPut<AdProvider>(() => AdProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<BlockProvider>(() => BlockProvider());
        }),
      ),
      GetPage(
        name: '/default',
        page: () => const Default(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<NoticeProvider>(() => NoticeProvider());
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<JingangProvider>(() => JingangProvider());
          Get.lazyPut<BlockProvider>(() => BlockProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<VChannelController>(() => VChannelController());
          Get.lazyPut<VNoticeController>(() => VNoticeController());
          Get.lazyPut<VJingangController>(() => VJingangController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());

          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<BundlingProductProvider>(() => BundlingProductProvider());
          Get.lazyPut<ProductProvider>(() => ProductProvider());
          Get.lazyPut<PaymentProvider>(() => PaymentProvider());
          Get.lazyPut<PrivilegeProvider>(() => PrivilegeProvider());
          Get.lazyPut<OrderProvider>(() => OrderProvider());

          Get.lazyPut<AdsProvider>(() => AdsProvider());
          Get.lazyPut<PositionProvider>(() => PositionProvider());

          Get.lazyPut<PhotoProvider>(() => PhotoProvider());
          Get.lazyPut<EventProvider>(() => EventProvider());
        }),
      ),
      GetPage(
        name: '/home',
        page: () => box.hasData('initialized')
            ? const HomePage(title: 'yes')
            : const HomePage(title: 'no'),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<NoticeProvider>(() => NoticeProvider());
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<JingangProvider>(() => JingangProvider());
          Get.lazyPut<BlockProvider>(() => BlockProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<VChannelController>(() => VChannelController());
          Get.lazyPut<VNoticeController>(() => VNoticeController());
          Get.lazyPut<VJingangController>(() => VJingangController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/layout/:layoutId',
        page: () => const LayoutPage(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          var noticeController = VNoticeController();
          var noticeProvider = NoticeProvider();
          Get.lazyPut<NoticeProvider>(() => noticeProvider);
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<JingangProvider>(() => JingangProvider());
          Get.lazyPut<BlockProvider>(() => BlockProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<VChannelController>(() => VChannelController());
          Get.lazyPut<VNoticeController>(() => noticeController);
          Get.lazyPut<VJingangController>(() => VJingangController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/story',
        page: () => const StoryPage(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
          Get.lazyPut<SupplierProvider>(() => SupplierProvider());
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
        }),
      ),
      GetPage(
        name: '/story/up/:upId',
        page: () => const StoryUpPage(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<VRegionController>(() => VRegionController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
          Get.lazyPut<SupplierProvider>(() => SupplierProvider());
        }),
      ),
      GetPage(
        name: '/story/tag/:tagId',
        page: () => const StoryTagPage(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<TagProvider>(() => TagProvider());
          Get.lazyPut<VRegionController>(() => VRegionController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
          Get.lazyPut<UserProvider>(() => UserProvider());
        }),
      ),
      GetPage(
        name: '/vod/:vodId/:coverId',
        page: () => const VodPlayerPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          // Get.putAsync<VNoticeController>(() async {
          //   return VNoticeController();
          // });
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<JingangProvider>(() => JingangProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<TagProvider>(() => TagProvider());
          Get.lazyPut<InternalTagProvider>(() => InternalTagProvider());
          Get.lazyPut<VVodController>(() => VVodController());
          Get.lazyPut<VChannelController>(() => VChannelController());
          Get.lazyPut<VNoticeController>(() => VNoticeController());
          Get.lazyPut<VJingangController>(() => VJingangController());
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
          Get.lazyPut<PositionProvider>(() => PositionProvider());
        }),
      ),
      GetPage(
        name: '/actors',
        page: () => const ActorsPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<ActorProvider>(() => ActorProvider());
          Get.lazyPut<RegionProvider>(() => RegionProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<VRegionController>(() => VRegionController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/actor/:actorId',
        page: () => const ActorPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<ActorProvider>(() => ActorProvider());
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/publishers',
        page: () => const PublishersPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<PublisherProvider>(() => PublisherProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/publisher/:publisherId',
        page: () => const PublisherPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<PublisherProvider>(() => PublisherProvider());
          Get.lazyPut<VPublisherController>(() => VPublisherController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/filter',
        page: () => const VodFilterPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<RegionProvider>(() => RegionProvider());
          Get.lazyPut<ActorProvider>(() => ActorProvider());
          Get.lazyPut<TagProvider>(() => TagProvider());
          Get.lazyPut<PublisherProvider>(() => PublisherProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
          Get.lazyPut<PositionProvider>(() => PositionProvider());
        }),
      ),
      GetPage(
        name: '/search',
        page: () => const SearchPage(),
        transition: Transition.noTransition,
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<TagProvider>(() => TagProvider());
          Get.lazyPut<SearchProvider>(() => SearchProvider());
          Get.lazyPut<VSearchController>(() => VSearchController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/search/:keyword',
        page: () => const SearchPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyPut<SearchProvider>(() => SearchProvider());
          Get.lazyPut<VSearchController>(() => VSearchController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/channel-settings/:layoutId',
        page: () => const ChannelSettingPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<ChannelProvider>(() => ChannelProvider());
          Get.lazyPut<VChannelController>(() => VChannelController());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member',
        page: () => const MemberPage(),
        transition: Transition.noTransition,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<PhotoProvider>(() => PhotoProvider());
          Get.lazyPut<EventProvider>(() => EventProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/share',
        page: () => const SharePage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/share/history',
        page: () => const ShareHistoryPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/share/tutorial',
        page: () => const ShareTutorialPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/upgrade',
        page: () => const MemberUpgradePage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<OtpProvider>(() => OtpProvider());
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/wallet',
        page: () => const MemberWalletPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<BundlingProductProvider>(() => BundlingProductProvider());
          Get.lazyPut<PaymentProvider>(() => PaymentProvider());
          Get.lazyPut<ProductProvider>(() => ProductProvider());
          Get.lazyPut<PrivilegeProvider>(() => PrivilegeProvider());
          Get.lazyPut<OrderProvider>(() => OrderProvider());
          Get.lazyPut<PointProvider>(() => PointProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/wallet/payment-result/:productId/:method',
        page: () => const PaymentResultPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<OrderProvider>(() => OrderProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/vip',
        page: () => const MemberVipPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<BundlingProductProvider>(() => BundlingProductProvider());
          Get.lazyPut<ProductProvider>(() => ProductProvider());
          Get.lazyPut<PaymentProvider>(() => PaymentProvider());
          Get.lazyPut<PrivilegeProvider>(() => PrivilegeProvider());
          Get.lazyPut<OrderProvider>(() => OrderProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/vip2',
        page: () => const MemberVipPage(refer: 'home'),
        transition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<BundlingProductProvider>(() => BundlingProductProvider());
          Get.lazyPut<ProductProvider>(() => ProductProvider());
          Get.lazyPut<PaymentProvider>(() => PaymentProvider());
          Get.lazyPut<PrivilegeProvider>(() => PrivilegeProvider());
          Get.lazyPut<OrderProvider>(() => OrderProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/settings',
        page: () => const MemberSettingsPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/setting/password',
        page: () => const MemberSettingsPasswordPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/setting/nickname',
        page: () => const MemberSettingNicknamePage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/record/history',
        page: () => const RecordHistoryPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/record/purchase',
        page: () => const RecordPurchasePage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<PointProvider>(() => PointProvider());
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/record/favorite',
        page: () => const RecordFavoritePage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/block/vods/:blockId/:channelId',
        page: () => const BlockMorePage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<VodProvider>(() => VodProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/messages',
        page: () => const MessageCenterPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProvider>(() => UserProvider());
          Get.lazyPut<NoticeProvider>(() => NoticeProvider());
          Get.lazyPut<EventProvider>(() => EventProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/ads',
        page: () => const MemberAdsPage(refer: 'home'),
        transition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<AdsProvider>(() => AdsProvider());
          Get.lazyPut<PositionProvider>(() => PositionProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/ads1',
        page: () => const MemberAdsPage(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<AdsProvider>(() => AdsProvider());
          Get.lazyPut<PositionProvider>(() => PositionProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
      GetPage(
        name: '/member/ticket',
        page: () => const MemberTicketPage(),
        transition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 168),
        popGesture: true,
        binding: BindingsBuilder(() {
          Get.lazyPut<RedemptionProvider>(() => RedemptionProvider());
          Get.lazyReplace<VBaseMenuCollection>(() => CMenuBarEarly());
        }),
      ),
    ],
  ));
}
