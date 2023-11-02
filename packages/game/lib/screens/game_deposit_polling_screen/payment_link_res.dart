import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/i18n.dart';

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
                      I18n.getRechargeUrl,
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
                        ? I18n.weAreTryingToGetTheRechargeUrlPleaseWait
                        : (submitDepositSuccess && isFetching == 'complete')
                            ? I18n.pleaseClickToOpenTheRechargePage
                            : I18n
                                .failedToGetTheWebsiteAddressPleaseChooseANewChannelOrContactCustomerService,
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
                    canOpenPayment ? I18n.cancel : I18n.close,
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
                      I18n.open,
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
