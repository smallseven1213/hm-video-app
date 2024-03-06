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
    return PhysicalModel(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: widget.isActive
                ? gameLobbyTabActiveBgColor
                : gameLobbyTabBgColor,
            borderRadius: BorderRadius.circular(8),
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
    );
  }
}
