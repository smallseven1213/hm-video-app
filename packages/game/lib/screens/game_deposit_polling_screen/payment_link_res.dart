import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class PaymentLinkRes extends StatefulWidget {
  final String amount;
  final int paymentChannelId;
  final String? userName;

  const PaymentLinkRes({
    super.key,
    required this.amount,
    required this.paymentChannelId,
    required this.userName,
  });

  @override
  PaymentLinkResState createState() => PaymentLinkResState();
}

class PaymentLinkResState extends State<PaymentLinkRes> {
  String redirectUrl = '';
  bool submitDepositSuccess = false;
  String isFetching = '';

  bool get canOpenPayment => submitDepositSuccess && redirectUrl != '';

  @override
  void initState() {
    super.initState();
    setState(() => isFetching = 'start');
    checkLinkRes(
      widget.amount,
      widget.paymentChannelId,
      widget.userName,
    );
  }

  void checkLinkRes(String amount, int paymentChannelId, String? name) async {
    try {
      var value = await GameLobbyApi().makeOrderV2(
        amount: amount,
        paymentChannelId: paymentChannelId,
        name: name,
      );
      logger.i('checkLinkRes value: $value');
      setState(() {
        redirectUrl = value;
        submitDepositSuccess = true;
        isFetching = 'complete';
      });
    } catch (e) {
      logger.e('checkLinkRes error: $e');
      setState(() {
        submitDepositSuccess = false;
        isFetching = 'complete';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isFetching == 'start')
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      localizations.translate('get_recharge_url'),
                      style: TextStyle(
                          color: gameLobbyPrimaryTextColor, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (isFetching == 'complete')
                  Icon(
                    submitDepositSuccess ? Icons.check_circle : Icons.cancel,
                    color: submitDepositSuccess ? Colors.green : Colors.red,
                    size: 70,
                  ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    isFetching == 'start'
                        ? localizations.translate(
                            'we_are_trying_to_get_the_recharge_url_please_wait')
                        : (submitDepositSuccess && isFetching == 'complete')
                            ? localizations.translate(
                                'please_click_to_open_the_recharge_page')
                            : localizations.translate(
                                'failed_to_get_the_website_address_please_choose_a_new_channel_or_contact_customer_service'),
                    style: TextStyle(color: gameLobbyPrimaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: canOpenPayment
                        ? gameLobbyButtonDisableColor
                        : gamePrimaryButtonColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                  },
                  child: Text(
                    canOpenPayment
                        ? localizations.translate('cancel')
                        : localizations.translate('close'),
                    style: TextStyle(
                      color: canOpenPayment
                          ? gameLobbyButtonDisableTextColor
                          : gamePrimaryButtonTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (canOpenPayment) const SizedBox(width: 20),
              if (canOpenPayment)
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: gamePrimaryButtonColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    onPressed: () => {
                      onLoading(context, status: false),
                      Navigator.pop(context),
                      launch(redirectUrl, webOnlyWindowName: '_blank'),
                      MyRouteDelegate.of(context)
                          .push(GameAppRoutes.paymentResult),
                    },
                    child: Text(
                      localizations.translate('open'),
                      style: TextStyle(
                          color: gamePrimaryButtonTextColor, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
