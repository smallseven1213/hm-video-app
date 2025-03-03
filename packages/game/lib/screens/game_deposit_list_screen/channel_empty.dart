import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get_storage/get_storage.dart';

import '../../localization/game_localization_delegate.dart';

class DepositChannelEmpty extends StatefulWidget {
  const DepositChannelEmpty({Key? key}) : super(key: key);

  @override
  State<DepositChannelEmpty> createState() => _DepositChannelEmptyState();
}

class _DepositChannelEmptyState extends State<DepositChannelEmpty> {
  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: gameItemMainColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .15),
            offset: Offset(0, 0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: SizedBox(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Image.asset(
                'packages/game/assets/images/game_deposit/payment_empty-$theme.webp',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 18),
              Text(
                GameLocalizations.of(context)!.translate(
                    'there_are_no_available_payment_channels_please_try_again_later_or_contact_customer_service'),
                style: const TextStyle(color: Color(0xFF979797)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
