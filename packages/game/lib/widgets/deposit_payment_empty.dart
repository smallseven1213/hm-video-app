import 'package:flutter/material.dart';
import 'package:game/localization/game_localization_delegate.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class PaymentEmpty extends StatelessWidget {
  const PaymentEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameLocalizations localizations = GameLocalizations.of(context)!;
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();

    return SizedBox(
      width: 110,
      height: 160,
      child: Center(
          child: Column(
        children: [
          Image.asset(
            'packages/game/assets/images/game_deposit/payment_empty-$theme.webp',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.translate('no_payment_channel'),
            style: TextStyle(color: gameLobbyPrimaryTextColor),
          ),
        ],
      )),
    );
  }
}
