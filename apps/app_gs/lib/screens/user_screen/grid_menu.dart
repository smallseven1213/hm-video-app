import 'package:app_gs/widgets/id_card.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/services/system_config.dart';
import 'package:url_launcher/url_launcher.dart';

final systemConfig = SystemConfig();

class GridMenuItem {
  final String name;
  final String icon;
  final Function onTap;

  GridMenuItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class GridMenu extends StatelessWidget {
  const GridMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      GridMenuItem(
        name: '我的足跡',
        icon: 'assets/images/user_screen_footprint.png',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.playRecord.value);
        },
      ),
      GridMenuItem(
        name: '我的喜歡',
        icon: 'assets/images/user_screen_like.png',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.favorites.value);
        },
      ),
      GridMenuItem(
        name: '我的收藏',
        icon: 'assets/images/user_screen_collection.png',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.collection.value);
        },
      ),
      GridMenuItem(
        name: '身份卡',
        icon: 'assets/images/user_screen_collection.png',
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: IDCard(),
              );
            },
          );
        },
      ),
      GridMenuItem(
        name: '推廣分享',
        icon: 'assets/images/user_screen_share.png',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.share.value);
        },
      ),
      // GridMenuItem(
      //   name: '在線客服',
      //   icon: 'assets/images/user_screen_online_service.png',
      //   onTap: () {
      //     logger.i(
      //         '${systemConfig.apiHost}/public/domains/domain/customer-services');
      //     launchUrl(Uri.parse(
      //         '${systemConfig.apiHost}/public/domains/domain/customer-services'));
      //   },
      // ),
      GridMenuItem(
        name: '應用中心',
        icon: 'assets/images/user_screen_app_center.png',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.apps.value);
        },
      ),
    ];
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var item = menuItems[index];
          return InkWell(
            onTap: item.onTap as void Function()?,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(item.icon),
                    width: 30,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: menuItems.length,
      ),
    );
  }
}
