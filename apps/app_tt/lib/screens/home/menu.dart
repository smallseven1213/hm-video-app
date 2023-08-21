import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import 'menu_item.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      color: Colors.white,
      child: ListView(
        children: [
          // MenuItem(
          //   icon: Icons.home,
          //   text: '我的足迹',
          //   onTap: () => print('Home tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '我的喜歡',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '我的收藏',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '身份卡',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '推廣分享',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '在線客服',
          //   onTap: () => print('Settings tapped'),
          // ),
          MenuItem(
            icon: Icons.settings,
            text: '應用中心',
            onTap: () {
              MyRouteDelegate.of(context).push(AppRoutes.apps);
            },
          ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '修改密碼',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '帳號憑證 ',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '個性設置',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '安全鎖設置',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '更新檢查',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '找回帳號',
          //   onTap: () => print('Settings tapped'),
          // ),
          // MenuItem(
          //   icon: Icons.settings,
          //   text: '登出',
          //   onTap: () => print('Settings tapped'),
          // ),
          UserInfoConsumer(child: ((info, isVIP, isGuest) {
            if (isGuest) {
              return MenuItem(
                icon: Icons.settings,
                text: '登入',
                onTap: () {
                  MyRouteDelegate.of(context).push(AppRoutes.login);
                },
              );
            } else {
              return const SizedBox();
            }
          })),
          UserInfoConsumer(child: ((info, isVIP, isGuest) {
            if (isGuest) {
              return MenuItem(
                icon: Icons.settings,
                text: '註冊',
                onTap: () {
                  MyRouteDelegate.of(context).push(AppRoutes.register);
                },
              );
            } else {
              return const SizedBox();
            }
          })),
        ],
      ),
    );
  }
}
