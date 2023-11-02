import 'package:flutter/material.dart';

import '../../localization/i18n.dart';

class PaymentDetailTips extends StatelessWidget {
  const PaymentDetailTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            I18n.warmTips,
            style: const TextStyle(
              color: Color(0xff999999),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            I18n.pleaseBeSureToProvideTrueInformationToFacilitateTheVerificationOfTheTransferData,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            I18n.pleaseWriteTheRequiredInformationInTheRemittanceRemarksToSpeedUpTheRechargeProcess,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }
}
