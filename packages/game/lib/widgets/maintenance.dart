import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

import '../localization/game_localization_delegate.dart';

class GameMaintenance extends StatelessWidget {
  const GameMaintenance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: gameLobbyBgColor,
      child: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'packages/game/assets/images/maintenance.webp',
                width: 86,
                height: 100,
              ),
              const SizedBox(height: 10),
              Text(
                localizations.translate('currently_under_maintenance'),
                style: TextStyle(
                  color: gameLobbyAppBarTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                localizations.translate('estimated_maintenance_time'),
                style: const TextStyle(
                  color: Color(0xff979797),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                localizations.translate(
                    'please_try_again_later_sorry_for_the_inconvenience'),
                style: const TextStyle(
                  color: Color(0xff979797),
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
