import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:game/screens/game_theme_config.dart';

class GameScrollViewTabs extends StatefulWidget {
  final String text;
  final String? icon;
  final bool isActive;
  const GameScrollViewTabs(
      {Key? key,
      required this.text,
      required this.icon,
      required this.isActive})
      : super(key: key);

  @override
  State<GameScrollViewTabs> createState() => _GameScrollViewTabsState();
}

class _GameScrollViewTabsState extends State<GameScrollViewTabs> {
  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();
  @override
  Widget build(BuildContext context) {
    // return 一個寬高52的Container，背景色#2c2c2c，borderRadius 8，內部是一個Column，放一個icon跟一個text
    // active的話，背景色要變成漸層
    // 漸層css參考 background-image: radial-gradient(circle at 50% 0%, #91d35f, rgba(44, 44, 44, 0) 74%), linear-gradient(to bottom, #2c2c2c, #2c2c2c);
    return Stack(children: [
      Positioned(
        top: 10, // 設定光暈的位置偏移量
        left: 10,
        child: Container(
          width: 35, // 設定光暈的尺寸
          height: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle, // 設定光暈的形狀
            color: Color.fromRGBO(0, 0, 0, .1), // 設定光暈的顏色
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, .1), // 設定光暈的顏色
                blurRadius: 15, // 設定光暈的模糊半徑
                spreadRadius: 1.5, // 設定光暈的擴散半徑
                offset: Offset(0, 0), // 設定光暈的偏移量
              ),
            ],
          ),
        ),
      ),
      PhysicalModel(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: RadialGradient(
                center: const Alignment(0, -1.3), // 設定放射狀的中心位置
                radius: 1, // 設定放射狀的半徑
                colors: widget.isActive
                    ? [
                        const Color(0xff91d35f),
                        gameLobbyBgColor,
                      ]
                    : [
                        gameLobbyTabBgColor,
                        gameLobbyTabBgColor,
                      ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.icon ??
                      'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                  width: 24,
                  height: 24,
                ),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: widget.isActive
                        ? gamePrimaryButtonColor
                        : gameLobbyPrimaryTextColor,
                    fontFeatures: const [
                      FontFeature.proportionalFigures(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // 光暈效果的容器，使用 Positioned.fill 使其覆蓋整個 Stack
    ]);
  }
}
